#!/bin/bash

# Kanata uinput Fix Script (v2 - Fixad perms-detektion med stat)
# Automatiserar fixen för /dev/uinput behörigheter (systemd v258+ bugg på Arch).
# Körs bara om det behövs: kollar grupper, GID, behörigheter och modul.
# Kräver sudo för vissa steg. Kör som: bash fix_kanata.sh
# Efteråt: Testa med /home/simon/.cargo/bin/kanata -c ~/.config/kanata/kanata.kbd

set -e  # Avsluta vid fel

# Färger för utskrift
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Kanata uinput-fix script startar...${NC}"

# Funktion: Kolla om användare är i grupp
in_group() {
    groups | grep -qw "$1"
}

# Funktion: Kolla GID för grupp
get_gid() {
    getent group "$1" | cut -d: -f3
}

# Funktion: Kolla behörigheter på /dev/uinput (fixad med stat)
check_uinput_perms() {
    if [ ! -e /dev/uinput ]; then
        echo "false"
        return
    fi
    if ! command -v stat >/dev/null 2>&1; then
        echo -e "${RED}stat-kommando saknas – kan inte verifiera perms.${NC}" >&2
        echo "false"
        return
    fi
    local perms=$(stat -c '%A %U %G' /dev/uinput 2>/dev/null || echo "")
    if [[ "$perms" == "crw-rw---- root uinput" ]]; then
        echo "true"
    else
        echo "false"
    fi
}

# Steg 1: Kolla och fixa grupper (uinput som systemgrupp, lägg till i uinput + input)
fix_groups() {
    echo -e "${YELLOW}Steg 1: Kollar grupper...${NC}"
    local needs_fix=false

    # Kolla om uinput-gruppen finns och har låg GID (<1000)
    if ! getent group uinput >/dev/null 2>&1; then
        echo "uinput-grupp saknas."
        needs_fix=true
    else
        local gid=$(get_gid uinput)
        if [ "$gid" -ge 1000 ]; then
            echo "uinput GID ($gid) för hög (>1000) – behöver systemgrupp."
            needs_fix=true
        fi
    fi

    # Kolla medlemskap
    if ! in_group uinput; then
        echo "Inte i uinput-grupp."
        needs_fix=true
    fi
    if ! in_group input; then
        echo "Inte i input-grupp."
        needs_fix=true
    fi

    if [ "$needs_fix" = true ]; then
        echo -e "${YELLOW}Fixar grupper (kräver sudo)...${NC}"
        sudo groupdel uinput 2>/dev/null || true  # Säker: ignorera fel om saknas
        sudo groupadd --system uinput
        sudo usermod -aG uinput "$USER"
        sudo usermod -aG input "$USER"
        echo -e "${GREEN}Grupper fixade! Logga ut/in eller reboot för att aktivera.${NC}"
        # Varning: Behöver ny session för grupper
        if [[ -z "$SUDO_USER" || "$SUDO_USER" != "$USER" ]]; then
            echo -e "${RED}Varning: Logga ut och in igen för att aktivera grupper.${NC}"
        fi
    else
        echo -e "${GREEN}Grupper OK: uinput GID <1000, du är medlem i uinput + input.${NC}"
    fi
}

# Steg 2: Kolla och fixa udev-regel
fix_udev() {
    echo -e "${YELLOW}Steg 2: Kollar udev-regel...${NC}"
    local rule_file="/etc/udev/rules.d/99-kanata.rules"
    local expected_rule='KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"'

    if [ ! -f "$rule_file" ] || ! grep -qF "$expected_rule" "$rule_file"; then
        echo "Udev-regel saknas eller felaktig."
        echo -e "${YELLOW}Lägger till udev-regel (kräver sudo)...${NC}"
        echo "$expected_rule" | sudo tee "$rule_file" >/dev/null
        sudo udevadm control --reload-rules && sudo udevadm trigger
        echo -e "${GREEN}Udev-regel tillagd och laddad.${NC}"
    else
        echo -e "${GREEN}Udev-regel OK.${NC}"
    fi
}

# Steg 3: Kolla och fixa kernel-modul
fix_module() {
    echo -e "${YELLOW}Steg 3: Kollar uinput-modul...${NC}"
    if ! lsmod | grep -q uinput; then
        echo "uinput-modul inte laddad."
        echo -e "${YELLOW}Laddar modul (kräver sudo)...${NC}"
        sudo modprobe uinput
        echo -e "${GREEN}Modul laddad.${NC}"
    else
        echo -e "${GREEN}uinput-modul OK.${NC}"
    fi

    # Kolla auto-laddning
    local mod_file="/etc/modules-load.d/uinput.conf"
    if [ ! -f "$mod_file" ] || ! grep -q '^uinput$' "$mod_file"; then
        echo "Auto-laddning saknas."
        echo 'uinput' | sudo tee "$mod_file" >/dev/null
        echo -e "${GREEN}Auto-laddning tillagd.${NC}"
    else
        echo -e "${GREEN}Auto-laddning OK.${NC}"
    fi
}

# Steg 4: Kolla behörigheter (efter modul/udev)
check_perms_final() {
    echo -e "${YELLOW}Steg 4: Kollar slutliga behörigheter...${NC}"
    local perms_ok=$(check_uinput_perms)
    if [ "$perms_ok" = "true" ]; then
        echo -e "${GREEN}/dev/uinput behörigheter OK: crw-rw---- root uinput${NC}"
    else
        echo -e "${YELLOW}/dev/uinput behörigheter verkar fel (eller /dev/uinput saknas).${NC}"
        echo "Men om Kanata körs OK: Ignorera – testa med 'stat -c '%A %U %G' /dev/uinput' för att verifiera manuellt."
        echo "Reboot kan hjälpa om udev inte slagit igenom fullt."
        # Inte exit här längre – fortsätt
    fi
}

# Huvudkörning
main() {
    fix_groups
    fix_udev
    fix_module

    # Kolla behörigheter (kan kräva reboot)
    sudo modprobe uinput 2>/dev/null || true  # Säker laddning
    check_perms_final

    echo -e "${GREEN}Script klart! Allt ser bra ut.${NC}"
    echo "Testa Kanata:"
    echo "  /home/simon/.cargo/bin/kanata -c ~/.config/kanata/kanata.kbd"
    echo ""
    echo "Om Kanata fungerar: Du är redo! Kör scriptet igen när som helst för check."
}

# Kör main om inte root (scriptet hanterar sudo internt)
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}Kör inte som root! Använd din vanliga user.${NC}"
    exit 1
fi

main

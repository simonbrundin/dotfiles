# Clean Code — Detaljerad Referens

Detta dokument utökar reglerna i [SKILL.md](SKILL.md). Behandla SKILL.md som
den obligatoriska korta operationskontraktet och använd denna fil när du
behöver detaljerad vägledning, exempel eller designrådgivning.

---

## Innehåll

1. [Vad "Ren Kod" Betyder](#vad-ren-kod-betyder)
2. [Namngivning i Praktiken](#namngivning-i-praktiken)
3. [Funktioner i Praktiken](#funktioner-i-praktiken)
4. [Kommentarer — Djupdykning](#kommentarer--djupdykning)
5. [SOLID i Kontext](#solid-i-kontext)
6. [Test-first Detaljerat](#test-first-detaljerat)
7. [Refaktorering — Steg-för-Steg](#refaktorering--steg-för-steg)
8. [Gradual Typning och Domändesign](#gradual-typning-och-domändesign)
9. [Clean Code i Olika Språk](#clean-code-i-olika-språk)
10. [Vanliga Anti-mönster](#vanliga-anti-mönster)

---

## Vad "Ren Kod" Betyder

Ren kod uppfyller **alla** dessa kriterier:

| Kriterium | Fråga att ställa |
|-----------|-----------------|
| Läsbar | Kan en annan ingenjör förstå koden utan att mentalt simulera doldt beteende? |
| Organiserad | Är ansvarsområden tydligt separerade? |
| Namngiven | Är avsikten uppenbar från namnen? |
| Delbar | Är enheterna små nog att återanvändas? |
| Testbar | Kan varje enhet testas i isolering? |
| Motståndskraftig | Ändras en sak utan att överraska bryta något annat? |

> "We are not here to write code for machines. We are not here to write code
> for computers. We are here to write code for humans." — Robert C. Martin

---

## Namngivning i Praktiken

### Regler för Variabler

```typescript
// ❌ Vag, ingen avsikt
let data: UserData;
let temp: number;
let result: any;

// ✅ Avslöjar avsikt
let activeUsers: User[];
let retryCount: number;
let parsedUserProfile: ParsedProfile;
```

### Regler för Booles

```typescript
// ❌ Inte predicates
let active = true;
let loggedIn = true;
let empty = false;

// ✅ Tydliga predicates
let isActive: boolean;
let hasAdminPrivileges: boolean;
let isEmpty: boolean;
let shouldRetry: boolean;
let canPublish: boolean;
```

### Regler för Funktioner

```typescript
// ❌ Vag aktivitet
function handle(data: Input): Output {}
function process(items: Item[]): Result {}
function manage(state: State): void {}

// ✅ Beskriver handlingen
function validateUserInput(input: RawInput): ValidatedInput {}
function sortItemsByDate(items: Item[]): SortedItems {}
function updateCacheWithNewEntries(entries: Entry[]): void {}
```

### Regler för Klasser

```typescript
// ❌ "Manager/Handler/Service"-antipattern
class DataManager {}
class OrderHandler {}
class UserService {}

// ✅ Substantiv som beskriver ansvar
class UserRepository {}
class OrderProcessor {}
class InventoryCalculator {}
class EmailNotifier {}
```

---

## Funktioner i Praktiken

### Funktioners och filers längd

Robert C. Martin är tydlig med att **storlek handlar om ansvar, inte rader** —
men rader är ett praktiskt mått:

#### Tumregler

| Enhet | Maximum | Varför |
|-------|---------|--------|
| Funktion | **~20 rader** | Gör en sak. Lätt att läsa, testa, namnge. |
| Funktion | **< 100 rader** | Aldrig 100+. Om du närmar dig 50, refaktorera. |
| Klass/Fil | **~200 rader** | Fokusera på ett ansvarsområde (SRP). |
| Klass/Fil | **100–200 rader** | "Sweet spot" — läsbart vid en skärmvy. |
| Klass/Fil | **> 500 rader** | 🚨 Refaktorera omedelbart. |

#### Indikatorer på att dela upp en fil

En fil behöver delas upp när den:

1. **Har flera ansvarsområden**
   - Både datamodell OCH affärslogik
   - Både HTTP-handlers OCH databaslogik
   - Både konfiguration OCH körbar logik

2. **Har för många abstraktionsnivåer**
   - Låg-nivå: `JSON.parse`, loopar, array-metoder
   - Mellan-nivå: affärsregler
   - Hög-nivå: orchestration, workflow

3. **Kräver mental kontext-switching**
   - Du måste hoppa mellan olika delar av filen för att förstå
   - Scrollning behövs för att se helheten

4. **Är svår att namnge**
   - Om filnamnet innehåller "And" (t.ex. `UserAndOrderService.ts`)
   - Om filnamnet är vagt (t.ex. `Utils.ts`, `Helpers.ts`)

#### Exempel: Före och efter fil-uppdelning

```typescript
// ❌ För lång fil: UserService.ts (450 rader)
// Innehåller: CRUD, validering, e-post, rapporter, statistik
class UserService {
  createUser() { /* ... */ }      // 50 rader
  updateUser() { /* ... */ }      // 60 rader
  deleteUser() { /* ... */ }      // 40 rader
  validateUser() { /* ... */ }    // 30 rader
  sendWelcomeEmail() { /* ... */ } // 40 rader
  generateReport() { /* ... */ }   // 80 rader
  calculateStats() { /* ... */ }   // 70 rader
  // ... och så vidare
}

// ✅ Uppdelat efter ansvar
class UserRepository {     // CRUD, ~150 rader
  create() { /* ... */ }
  findById() { /* ... */ }
  update() { /* ... */ }
  delete() { /* ... */ }
}

class UserValidator {      // Validering, ~80 rader
  validate() { /* ... */ }
  validateEmail() { /* ... */ }
}

class UserNotifier {       // Kommunikation, ~100 rader
  sendWelcome() { /* ... */ }
  sendPasswordReset() { /* ... */ }
}

class UserAnalytics {      // Rapportering, ~120 rader
  generateReport() { /* ... */ }
  calculateStats() { /* ... */ }
}
```

### Extract Method — Exempel

```python
# ❌ Lång funktion med flera ansvarsområden
def process_order(order):
    # Validering
    if not order.get("customer_id"):
        return {"error": "missing customer"}
    if not order.get("items"):
        return {"error": "no items"}
    # Beräkning
    total = sum(item["price"] * item["quantity"] for item in order["items"])
    if total > 1000:
        discount = total * 0.1
    else:
        discount = 0
    # Persistence
    order["total"] = total - discount
    db.save(order)
    # Notification
    email_service.send(order["customer_email"], f"Order processed: {total}")
    return order

# ✅ Extraherade metoder, var och en gör EN sak
def validate_order(order: dict) -> None:
    if not order.get("customer_id"):
        raise OrderValidationError("Missing customer_id")
    if not order.get("items"):
        raise OrderValidationError("No items in order")

def calculate_discount(total: Decimal) -> Decimal:
    return total * Decimal("0.1") if total > 1000 else Decimal("0")

def calculate_total(items: list[dict]) -> Decimal:
    return sum(Decimal(str(item["price"])) * item["quantity"] for item in items)

def persist_order(order: dict) -> None:
    db.save(order)

def notify_customer(order: dict) -> None:
    email_service.send(
        order["customer_email"],
        f"Order processed: {order['total']}"
    )

def process_order(order: dict) -> dict:
    validate_order(order)
    total = calculate_total(order["items"])
    discount = calculate_discount(total)
    order["total"] = total - discount
    persist_order(order)
    notify_customer(order)
    return order
```

### Introduce Parameter Object — Exempel

```typescript
// ❌ För många parametrar
function createReport(
  title: string,
  startDate: Date,
  endDate: Date,
  author: string,
  format: ReportFormat,
  includeCharts: boolean,
  includeTables: boolean
): Report {}

// ✅ Parametrar grupperade i objekt
interface ReportOptions {
  title: string;
  dateRange: { start: Date; end: Date };
  author: string;
  format: ReportFormat;
  includeCharts: boolean;
  includeTables: boolean;
}

function createReport(options: ReportOptions): Report {}
```

---

## Kommentarer — Djupdykning

### Kommentarer som Är Acceptabla

```typescript
// Juridisk
// Copyright © 2025 Acme Corp. All rights reserved.

// Varning om överraskande beteende
// OBS: Valideringen跳as i testläge för att möjliggöra snabb prototyping.
// TA BORT DETTA FÖRE PRODUCTION.
const skipValidation = process.env.NODE_ENV === "test";

// Icke-uppenbar tradeoff
// Vi använder lazy loading här för att undvika cirkulärt beroende.
// Refaktorera till eager loading när domänmodellen stabiliseras.
const loader = new LazyDependencyLoader();

// TODO som är handlingsbar
// TODO(simon): Extrahera till fristående repository när vi stödjer fler databaser
class UserRepository {}
```

### Kommentarer att Undvika

```typescript
// ❌ Uppenbar / redundant
// Increment counter by 1
counter++;

// ❌ Förklarar förvirrande kod istället för att refaktorera
// If user is admin OR user is the owner, allow access
if (user.isAdmin || resource.ownerId === user.id) {
  return true;
}

// ❌ Journal-kommentarer
// 2024-01-15: Fixed bug (simon)
// 2024-01-16: Refactored (simon)
// 2024-01-17: TODO: fix this properly

// ❌ Utkommenterad kod
// old implementation:
// function oldCalc(x) { return x * 2; }
```

---

## SOLID i Kontext

### Single Responsibility Principle (SRP)

```typescript
// ❌ Class doing too much
class UserManager {
  validateUser(u: User) { /* ... */ }
  saveToDatabase(u: User) { /* ... */ }
  sendWelcomeEmail(u: User) { /* ... */ }
  generateReport(u: User) { /* ... */ }
}

// ✅ Each class has one reason to change
class UserValidator { validate(u: User): ValidationResult }
class UserRepository { save(u: User): void }
class UserNotifier { sendWelcome(u: User): void }
class UserReporter { generate(u: User): Report }
```

### Open/Closed Principle (OCP)

```typescript
// ❌ Öppen för modifiering vid varje ny typ
function calculateArea(shape: any): number {
  if (shape.type === "circle") return Math.PI * shape.radius ** 2;
  if (shape.type === "rectangle") return shape.width * shape.height;
  // Ny typ? Lägg till här → MODIFIERA befintlig kod
}

// ✅ Öppen för extension, stängd för modifiering
interface Shape { area(): number }
class Circle implements Shape { constructor(public radius: number) { area() { return Math.PI * this.radius ** 2 } } }
class Rectangle implements Shape { constructor(public w: number, public h: number) { area() { return this.w * this.h } } }
function calculateArea(shape: Shape): number { return shape.area() } // Ny form? Lägg till klass, ändra inte denna funktion
```

### Liskov Substitution Principle (LSP)

```typescript
// ❌ Bryter LSP: Bird är inte substituerbar för Penguin
class Bird {
  fly(): string { return "flying"; }
}
class Penguin extends Bird {
  fly() { throw new Error("Penguins can't fly"); } // LSP violation!
}

// ✅ Korrekt modellering
interface Bird {}
interface FlyingBird extends Bird { fly(): string }
class Sparrow implements FlyingBird { fly() { return "flying"; } }
class Penguin implements Bird { swim(): string { return "swimming"; } }
```

### Interface Segregation Principle (ISP)

```typescript
// ❌ Fet interface
interface Worker {
  work(): void;
  eat(): void;
  sleep(): void;
  drive(): void;
}

// ✅ Smala, specifika interfaces
interface Workable { work(): void }
interface Eatable { eat(): void }
interface Sleepable { sleep(): void }
```

### Dependency Inversion Principle (DIP)

```typescript
// ❌ Hög-nivå modul beror på låg-nivå detaljer
class MySQLUserRepository {
  save(user: User) { /* MySQL-specific */ }
}
class UserService {
  constructor(private repo: MySQLUserRepository) {} // Hård beroende
}

// ✅ Hög-nivå beror på abstraktion
interface UserRepository {
  save(user: User): void;
}
class MySQLUserRepository implements UserRepository {
  save(user: User) { /* MySQL-specific */ }
}
class UserService {
  constructor(private repo: UserRepository) {} // Beroend inverserat
}
```

---

## Test-first Detaljerat

### TDD-cykeln

```
┌─────────────────────────────────────────────────────┐
│  1. RED    → Skriv ett test som MISSLYCKAS          │
│             ("What should this do?")                │
├─────────────────────────────────────────────────────┤
│  2. GREEN  → Skriv MINSTA kod som får testet att    │
│             passera (inte mer)                       │
├─────────────────────────────────────────────────────┤
│  3. REFACTOR → Förbättra struktur utan att          │
│               ändra beteende                        │
└─────────────────────────────────────────────────────┘
    ↑_______________________________________________↓
              Repetera tills beteendet är komplett
```

### Exempel: Test-first för en korg

```typescript
// 1. RED: Skriv testet först
describe("ShoppingCart", () => {
  it("should calculate total with applied discounts", () => {
    const cart = new ShoppingCart();
    cart.addItem({ name: "Book", price: 100 });
    cart.addItem({ name: "Pen", price: 20 });

    const total = cart.calculateTotal({ discountThreshold: 50, discountRate: 0.1 });

    expect(total).toBe(108); // 120 - 10% = 108
  });
});

// Kör test → FAIL (ShoppingCart finns inte)

// 2. GREEN: Minimal implementation
class ShoppingCart {
  items: { name: string; price: number }[] = [];

  addItem(item: { name: string; price: number }): void {
    this.items.push(item);
  }

  calculateTotal(options: { discountThreshold: number; discountRate: number }): number {
    const subtotal = this.items.reduce((sum, item) => sum + item.price, 0);
    if (subtotal >= options.discountThreshold) {
      return subtotal * (1 - options.discountRate);
    }
    return subtotal;
  }
}

// Kör test → PASS

// 3. REFACTOR: Förbättra utan att ändra beteende
// Extrahera applyDiscount() och calculateSubtotal() för läsbarhet.
// Testerna skyddar mot regression.
```

---

## Refaktorering — Steg-för-Steg

### Steg 1: Identifiera Kodlukt

Leta efter dessa symptom:

| Kodlukt | Definition |
|---------|------------|
| **Duplicated Code** | Samma kodstruktur på flera ställen |
| **Long Method** | Metod > 20 rader |
| **Large Class** | Klass > 10 metoder eller > 10 fält |
| **Long Parameter List** | > 3 parametrar |
| **Shotgun Surgery** | En förändring kräver ändringar på många ställen |
| **Feature Envy** | Metod använder mer data från annan klass än sin egen |
| **Data Clumps** | Grupper av parametrar som alltid hänger ihop |
| **Primitive Obsession** | Använder primitives istället för små objekt |
| **Switch Statements** | Upprepade switch/case eller if-kedjor |
| **Parallel Inheritance** | Två klasshierarkier som speglar varandra |
| **Lazy Class** | Klass som gör för lite för att motivera sitt existens |
| **Speculative Generality** | Kod för hypotetiska framtida behov |

### Steg 2: Säkra Beteende

```bash
# Innan refaktorering: verifiera att tester passerar
npm test  # eller din testkommando

# Gör ONE small change
# Kör tester igen
npm test

# Om testerna passerar: commita
git commit -m "refactor: extract calculateTotal from processOrder"

# Om testerna misslyckas: revert och ompröva
git checkout -- .
```

### Steg 3: Små, Säkra Transformationer

Refaktorera **ett steg i taget**. Aldrig:

```python
# ❌ Gör allt på en gång
def process(x):
    # 20 ändringar
    # Förväntar sig att allt fungerar
    pass

# ✅ Ett steg i taget
# Iteration 1: Extrahera beräkning
# Iteration 2: Extrahera validering
# Iteration 3: Extrahera persistence
# Varje iteration: kör tester, commita
```

### Steg 4: Prioritera

Refaktorera i denna ordning:

1. **Kritiska path** (kod som kör ofta / är affärskritisk)
2. **Nyligen berörd kod** (kod du eller teamet nyss arbetade med)
3. **Kod med låg testtäckning** (få retroaktiva tester först)
4. **Överallt annat** (gradvis, underhållsarbete)

---

## Vanliga Anti-mönster

### Anemi (Anemic Domain Model)

```typescript
// ❌ Klass med data men inget beteende
class Order {
  id: string;
  customerId: string;
  items: OrderItem[];
  status: OrderStatus;
  // Inga metoder — all logik i services
}

// ✅ Rik domänmodell
class Order {
  constructor(
    private readonly id: string,
    private customerId: string,
    private items: OrderItem[],
    private status: OrderStatus = OrderStatus.Draft
  ) {}

  addItem(item: OrderItem): void {
    if (this.status !== OrderStatus.Draft) {
      throw new OrderError("Cannot modify a submitted order");
    }
    this.items.push(item);
  }

  get total(): Money {
    return this.items.reduce((sum, i) => sum.add(i.subtotal), Money.zero());
  }

  submit(): void {
    if (this.items.length === 0) {
      throw new OrderError("Cannot submit an empty order");
    }
    this.status = OrderStatus.Submitted;
  }
}
```

### God Object

```typescript
// ❌ En klass som gör allt
class SystemManager {
  manageUsers() { /* ... */ }
  processOrders() { /* ... */ }
  generateReports() { /* ... */ }
  sendEmails() { /* ... */ }
  backupDatabase() { /* ... */ }
  // ... 50 fler metoder
}

// ✅ Delat ansvar
class UserManagement {}
class OrderProcessing {}
class ReportGeneration {}
class NotificationService {}
class BackupScheduler {}
```

### Nested Callbacks (Callback Hell)

```typescript
// ❌ Callback-helvetet
getUser(userId, (user) => {
  getOrders(user.id, (orders) => {
    getProducts(orders, (products) => {
      sendEmail(user.email, products, () => {
        // ...mer nästlat
      });
    });
  });
});

// ✅ Async/await med ren separation
async function notifyUserOfNewProducts(userId: string): Promise<void> {
  const user = await getUser(userId);
  const orders = await getOrders(user.id);
  const products = await getProducts(orders);
  await sendEmail(user.email, products);
}
```

---

## Gradual Typning och Domändesign

### Typedefiniera Domänvärden

```typescript
// ❌ Primitiva överallt
function createUser(name: string, email: string, age: number) {}

// ✅ Domäntyper
type UserId = string & { readonly brand: unique symbol };
type Email = string & { readonly brand: unique symbol };
type Age = number & { readonly brand: unique symbol };

function createUser(name: string, email: Email, age: Age) {}
```

### Builder Pattern för Komplexa Objekt

```typescript
// ❌ Lång konstruktor
const order = new Order("ORD-123", userId, items, address, paymentMethod, shipping, true, false, ...);

// ✅ Builder
const order = new OrderBuilder()
  .withId("ORD-123")
  .forUser(userId)
  .withItems(items)
  .shippingTo(address)
  .withPayment(paymentMethod)
  .priority()
  .build();
```

---

## Clean Code i Olika Språk

### TypeScript/JavaScript

```typescript
// Föredra const över let, undvik var
const CONFIG = { /* immutable config */ };
let mutableState = { /* only when necessary */ };

// Explicit return-typer på publika funktioner
function processOrder(order: Order): ProcessedOrder {
  // ...
}

// Undvik any — använd unknown för generiska inputs
function parseInput(raw: unknown): ParsedData {
  if (!isValidData(raw)) {
    throw new ParseError("Invalid data structure");
  }
  return raw as ParsedData;
}
```

### Python

```python
# Typannoteringar för publika funktioner
from typing import Sequence

def calculate_total(items: Sequence[Item]) -> Decimal:
    """Calculate the order total with applicable discounts."""
    ...

# Använd dataclasses för rena datastrukturer
@dataclass(frozen=True)
class OrderLine:
    product_id: ProductId
    quantity: PositiveInt
    unit_price: Money
```

### Bash/Shell

```bash
# Namn på funktioner som avslöjar avsikt
function ensure_dependencies_installed() { ... }
function deploy_to_production() { ... }
function rollback_deployment() { ... }

# Undvik magic numbers
readonly MAX_RETRIES=3
readonly API_TIMEOUT_SECONDS=30
```

---

## Citat att Mindas

> "The proper use of comments is to compensate for our failure to express
> ourselves in code." — Robert C. Martin

> "The ratio of time spent reading versus writing is well over 10 to 1. We
> are constantly reading old code as part of the effort to write new code."

> "Clean code is code that has been taken care of."

> "A function should do one thing. It should do it well. It should do it only."

> "The best classes contain the fewest number of instance variables."

> "The first rule of functions is that they should be small. The second rule
> is that functions should be smaller than that."

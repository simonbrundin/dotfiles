import {
  duoLayer,
  FromKeyParam,
  ifApp,
  ifDevice,
  ifVar,
  layer,
  hyperLayer,
  map,
  mapSimultaneous,
  rule,
  to$,
  toApp,
  ToEvent,
  toKey,
  toMouseCursorPosition,
  toPaste,
  toPointingButton,
  toRemoveNotificationMessage,
  toSleepSystem,
  toUnsetVar,
  withCondition,
  withMapper,
  withModifier,
  writeToProfile,
} from "https://deno.land/x/karabinerts@1.30.3/deno.ts";

import {
  duoModifiers,
  historyNavi,
  raycastExt,
  raycastWin,
  switcher,
  tabNavi,
  tapModifiers,
  toClearNotifications,
  toResizeWindow,
  toSystemSetting,
} from "./utils.ts";

function main() {
  writeToProfile(
    "Default",
    [
      hyperKey(),
      mehKey(),
      app_homerow(),
      deleteWord(),
      // capsLockToEscape(),
      layer_terminal_sessions(),
      // homerowMods(),
      rule_duoModifiers(),
      // rule_leaderKey()
      // ,
      toggleTmuxWindows(),
      newGrok(),
      // layer_symbol(),
      layer_digitAndDelete(),
      layer_snippet(),
      // layer_launchApp(),
      layer_openLink(),
      // layer_system(),
      app_ghostty(),
      // app_chrome(),
      // app_safari(),
      // app_jetBrainsIDE(),
      // app_zed(),
      // app_vsCode(),
      // app_cursor(),
      // app_slack(),
      // app_warp(),
      // app_spark(),
      // app_zoom(),
      // app_chatGPT(),

      // app_raycast(),

      // keyboard_apple(),
      // keyboard_moonlander(),
      layer_meh(),
      layer_hyper(),
    ],
    {
      "basic.simultaneous_threshold_milliseconds": 50,
      "basic.to_if_held_down_threshold_milliseconds": 200,
      "duo_layer.threshold_milliseconds": 50,
      "duo_layer.notification": true,
    },
  );
}

function hyperKey() {
  return rule("HyperKey = ").manipulators([
    map("caps_lock").toHyper().toIfAlone("escape"),
  ]);
}

function mehKey() {
  return rule("Meh").manipulators(
    map("right_command").toMeh().toIfAlone("b", "left_control"),
  );
}

function homerowMods() {
  return rule("Home row mods - shift, ctrl, alt, cmd").manipulators([
    //
    // Four - left hand
    mapSimultaneous(["a", "s", "d", "f"]).toIfHeldDown("l⌘", ["l⌥⌃⇧"]),
    //
    // Three - left hand
    mapSimultaneous(["a", "s", "d"]).toIfHeldDown("l⌘", ["l⌥⌃"]),
    mapSimultaneous(["a", "d", "f"]).toIfHeldDown("l⌘", ["l⌃⇧"]),
    mapSimultaneous(["s", "d", "f"]).toIfHeldDown("l⌥", ["l⌃⇧"]),
    //
    // Two - left hand
    mapSimultaneous(["a", "s"], { key_down_order: "strict" })
      .toIfAlone("a")
      .toIfAlone("s")
      .toIfHeldDown("l⌘", "l⌥"),
    mapSimultaneous(["s", "a"], { key_down_order: "strict" })
      .toIfAlone("s")
      .toIfAlone("a")
      .toIfHeldDown("l⌘", "l⌥"),
    mapSimultaneous(["a", "d"], { key_down_order: "strict" })
      .toIfAlone("a")
      .toIfAlone("d")
      .toIfHeldDown("l⌘", "l⌃"),
    mapSimultaneous(["d", "a"], { key_down_order: "strict" })
      .toIfAlone("d")
      .toIfAlone("a")
      .toIfHeldDown("l⌘", "l⌃"),
    mapSimultaneous(["a", "f"], { key_down_order: "strict" })
      .toIfAlone("a")
      .toIfAlone("f")
      .toIfHeldDown("l⌘", "l⇧"),
    mapSimultaneous(["f", "a"], { key_down_order: "strict" })
      .toIfAlone("f")
      .toIfAlone("a")
      .toIfHeldDown("l⌘", "l⇧"),
    mapSimultaneous(["s", "d"], { key_down_order: "strict" })
      .toIfAlone("s")
      .toIfAlone("d")
      .toIfHeldDown("l⌥", "l⌃"),
    mapSimultaneous(["d", "s"], { key_down_order: "strict" })
      .toIfAlone("d")
      .toIfAlone("s")
      .toIfHeldDown("l⌥", "l⌃"),
    mapSimultaneous(["s", "f"], { key_down_order: "strict" })
      .toIfAlone("s")
      .toIfAlone("f")
      .toIfHeldDown("l⌥", "l⇧"),
    mapSimultaneous(["f", "s"], { key_down_order: "strict" })
      .toIfAlone("f")
      .toIfAlone("s")
      .toIfHeldDown("l⌥", "l⇧"),
    mapSimultaneous(["d", "f"], { key_down_order: "strict" })
      .toIfAlone("d")
      .toIfAlone("f")
      .toIfHeldDown("l⌃", "l⇧"),
    mapSimultaneous(["f", "d"], { key_down_order: "strict" })
      .toIfAlone("f")
      .toIfAlone("d")
      .toIfHeldDown("l⌃", "l⇧"),
    //
    // One - left hand
    map("a")
      .toIfAlone("a", {}, { halt: true })
      .toDelayedAction(toKey("vk_none"), toKey("a"))
      .toIfHeldDown("l⌘", {}, { halt: true }),
    map("s")
      .toIfAlone("s", {}, { halt: true })
      .toDelayedAction(toKey("vk_none"), toKey("s"))
      .toIfHeldDown("l⌥", {}, { halt: true }),
    map("d")
      .toIfAlone("d", {}, { halt: true })
      .toDelayedAction(toKey("vk_none"), toKey("d"))
      .toIfHeldDown("l⌃", {}, { halt: true }),
    map("f")
      .toIfAlone("f", {}, { halt: true })
      .toDelayedAction(toKey("vk_none"), toKey("f", {}, { halt: true }))
      .toIfHeldDown("l⇧", {}, { halt: true }),
    //
    //
    // Four - right hand
    mapSimultaneous(["j", "k", "l", ";"]).toIfHeldDown("r⌘", ["r⌥⌃⇧"]),
    //
    // Three - right hand
    mapSimultaneous([";", "l", "k"]).toIfHeldDown("r⌘", ["r⌥⌃"]),
    mapSimultaneous([";", "k", "j"]).toIfHeldDown("r⌘", ["r⌃⇧"]),
    mapSimultaneous(["l", "k", "j"]).toIfHeldDown("r⌥", ["r⌃⇧"]),
    //
    // Two - right hand
    mapSimultaneous([";", "l"], { key_down_order: "strict" })
      .toIfAlone(";")
      .toIfAlone("l")
      .toIfHeldDown("r⌘", "r⌥"),
    mapSimultaneous(["l", ";"], { key_down_order: "strict" })
      .toIfAlone("l")
      .toIfAlone(";")
      .toIfHeldDown("r⌘", "r⌥"),
    mapSimultaneous([";", "k"], { key_down_order: "strict" })
      .toIfAlone(";")
      .toIfAlone("k")
      .toIfHeldDown("r⌘", "r⌃"),
    mapSimultaneous(["k", ";"], { key_down_order: "strict" })
      .toIfAlone("k")
      .toIfAlone(";")
      .toIfHeldDown("r⌘", "r⌃"),
    mapSimultaneous([";", "j"], { key_down_order: "strict" })
      .toIfAlone(";")
      .toIfAlone("j")
      .toIfHeldDown("r⌘", "r⇧"),
    mapSimultaneous(["j", ";"], { key_down_order: "strict" })
      .toIfAlone("j")
      .toIfAlone(";")
      .toIfHeldDown("r⌘", "r⇧"),
    mapSimultaneous(["l", "k"], { key_down_order: "strict" })
      .toIfAlone("l")
      .toIfAlone("k")
      .toIfHeldDown("r⌥", "r⌃"),
    mapSimultaneous(["k", "l"], { key_down_order: "strict" })
      .toIfAlone("k")
      .toIfAlone("l")
      .toIfHeldDown("r⌥", "r⌃"),
    mapSimultaneous(["l", "j"], { key_down_order: "strict" })
      .toIfAlone("l")
      .toIfAlone("j")
      .toIfHeldDown("r⌥", "r⇧"),
    mapSimultaneous(["j", "l"], { key_down_order: "strict" })
      .toIfAlone("j")
      .toIfAlone("l")
      .toIfHeldDown("r⌥", "r⇧"),
    mapSimultaneous(["k", "j"], { key_down_order: "strict" })
      .toIfAlone("k")
      .toIfAlone("j")
      .toIfHeldDown("r⌃", "r⇧"),
    mapSimultaneous(["j", "k"], { key_down_order: "strict" })
      .toIfAlone("j")
      .toIfAlone("k")
      .toIfHeldDown("r⌃", "r⇧"),
    //
    // One - right hand
    map("semicolon")
      .toIfAlone("semicolon", {}, { halt: true })
      .toDelayedAction(toKey("vk_none"), toKey(";"))
      .toIfHeldDown("r⌘", {}, { halt: true }),
    map("l")
      .toIfAlone("l", {}, { halt: true })
      .toDelayedAction(toKey("vk_none"), toKey("l"))
      .toIfHeldDown("r⌥", {}, { halt: true }),
    map("k")
      .toIfAlone("k", {}, { halt: true })
      .toDelayedAction(toKey("vk_none"), toKey("k"))
      .toIfHeldDown("r⌃", {}, { halt: true }),
    map("j")
      .toIfAlone("j", {}, { halt: true })
      .toDelayedAction(toKey("vk_none"), toKey("j"))
      .toIfHeldDown("r⇧", {}, { halt: true }),
  ]);
}

function toggleTmuxWindows() {
  return rule(
    "Command + J to Control + Y in Ghostty",
    ifApp({ bundle_identifiers: ["com.mitchellh.ghostty"] }),
  ).manipulators([map("j", "Meh").to("y", "left_control")]);
}

function newGrok() {
  return rule("Öppnar ny Grok", ifApp("Grok")).manipulators([
    map("l", "Meh").to("j", "right_control"),
  ]);
}

function deleteWord() {
  return rule("Delete word").manipulators([
    map("left_command")
      .toIfAlone("delete_or_backspace", "left_option")
      .toIfHeldDown("left_command")
      .to("left_command"),
  ]);
}

function rule_duoModifiers() {
  return rule("duo-modifiers").manipulators(
    duoModifiers({
      "⌘": ["fd", "jk"],
      "⌃": ["fs", "jl"], // ⌃ second as Vim uses it
      "⌥": ["fa", "j;"], // ⌥ last as used the least

      "⇧": ["ds", "kl"],

      "⌘⇧": ["gd", "hk"],
      "⌃⇧": ["gs", "hl"],
      "⌥⇧": ["ga", "h;"],

      "⌘⌥": ["vc", "m,"],
      "⌘⌃": ["vx", "m."],
      "⌥⌃": ["cx", ",."],

      "⌘⌥⌃": ["vz", "m/"],
    }),
  );
}

// function rule_leaderKey() {
//   let _var = "leader";
//   let escape = [toUnsetVar(_var), toRemoveNotificationMessage(_var)];

//   let mappings = {
//     e: {
//       name: "Emoji",
//       mapping: {
//         c: "📅", // Calendar
//         h: "💯", // Hundred
//         j: "😂", // Joy
//         p: "👍", // Plus_one +1
//         s: "😅", // Sweat_smile
//         t: "🧵", // Thread
//       },
//       action: toPaste,
//     },
//     g: {
//       name: "Gitmoji", // See https://gitmoji.dev/
//       mapping: {
//         b: "🐛", // fix a Bug
//         d: "📝", // add or update Documentation
//         f: "🚩", // add, update, or remove Feature Flags
//         m: "🔀", // Merge branches
//         n: "✨", // introduce New features
//         r: "♻️", // Refactor code
//         u: "💄", // UI/Style
//         v: "🔖", // release / Version tags
//       },
//       action: toPaste,
//     },
//     r: {
//       name: "Raycast",
//       mapping: {
//         c: ["raycast/calendar/my-schedule", "Calendar"],
//         d: ["raycast/dictionary/define-word", "Dictionary"],
//         e: ["raycast/emoji-symbols/search-emoji-symbols", "Emoji"],
//         g: ["ricoberger/gitmoji/gitmoji", "Gitmoji"],
//         s: ["raycast/snippets/search-snippets", "Snippets"],
//         v: ["raycast/clipboard-history/clipboard-history", "Clipboard"],
//       },
//       action: raycastExt,
//     },
//     s: {
//       name: "SystemSetting",
//       mapping: {
//         a: "Appearance",
//         d: "Displays",
//         k: "Keyboard",
//         o: "Dock",
//       },
//       action: toSystemSetting,
//     },
//   } satisfies {
//     [key: string]: {
//       name: string;
//       mapping: { [key: string]: string | string[] };
//       action: (v: string) => ToEvent | ToEvent[];
//     };
//   };

//   let keys = Object.keys(mappings) as Array<keyof typeof mappings>;
//   let hint = keys.map((x) => `${x}_${mappings[x].name}`).join(" ");

//   return rule("Leader Key").manipulators([
//     // 0: Inactive -> Leader
//     withCondition(ifVar(_var, 0))([
//       mapSimultaneous(["f", "l"], undefined, 250)
//         .toVar(_var, 1)
//         .toNotificationMessage(_var, hint),
//     ]),

//     // 0.unless: Leader or NestedLeader -> Inactive
//     withCondition(ifVar(_var, 0).unless())([
//       withMapper(["⎋", "⇪"])((x) => map(x).to(escape)),
//     ]),

//     // 1: Leader -> NestedLeader
//     withCondition(ifVar(_var, 1))(
//       keys.map((k) => {
//         let hint = Object.entries(mappings[k].mapping)
//           .map(([k, v]) => `${k}_${Array.isArray(v) ? v[1] : v}`)
//           .join(" ");
//         return map(k).toVar(_var, k).toNotificationMessage(_var, hint);
//       })
//     ),

//     // NestLayer
//     ...keys.map((nestedLeaderKey) => {
//       let { mapping, action } = mappings[nestedLeaderKey];
//       let actionKeys = Object.keys(mapping) as Array<keyof typeof mapping>;
//       return withCondition(ifVar(_var, nestedLeaderKey))(
//         actionKeys.map((x) => {
//           let v = Array.isArray(mapping[x]) ? mapping[x][0] : mapping[x];
//           return map(x).to(action(v)).to(escape);
//         })
//       );
//     }),
//   ]);
// }

function layer_meh() {
  return rule("Meh Layer").manipulators([
    map("c", "Meh").toApp("Calendar"),
    map("j", "Meh").toApp("Ghostty"),
    map("h", "Meh").to$(
      "open https://simonsha.duckdns.org:8123/lovelace/default_view",
    ),
    // map("l", "Meh").to$(
    //   "osascript -e 'tell application \"Grok\" to activate' && " +
    //     // "osascript -e 'tell application \"System Events\" to delay 0.5' && " + // Ökad fördröjning för att säkerställa aktivering
    //     "osascript -e 'tell application \"System Events\" to key code 36 using {shift down, control down, option down, command down}' && " +
    //     "osascript -e 'tell application \"System Events\" to delay 0.1' && " +
    //     'osascript -e \'tell application "System Events" to keystroke "hur kan grok hjälpa till"\' && ' +
    //     "osascript -e 'tell application \"System Events\" to delay 0.1' && " +
    //     "osascript -e 'tell application \"System Events\" to key code 36'", // Ingen extra && eller komma
    // ),
    map("k", "Meh").toApp("Google Chrome"),
    // map("p", "Meh").toApp("Plan"),
    map("p", "Meh").to$(
      "open notion://www.notion.so/simonbrundin/Innan-Plan-1-0-24dc596a43ee807d9192e6c3e48c4e45?source=copy_link",
    ),
    map("l", "Meh").toApp("Chat"),
    map("o", "Meh").to$("open https://headlamp.simonbrundin.com"),
    map("x", "Meh").toApp("Grok"),
    map("d", "Meh").toApp("Discord"),
    map("g", "Meh").toApp("ChatGPT"),
    map("s", "Meh").toApp("Spotify"),
    map("n", "Meh").toApp("Notion"),
    map("u", "Meh").toApp("UniFi"),
    //map("u", "Meh").to$(
    //   `open 'https://unifi.ui.com/consoles/0CEA145690E500000000087652220000000008E9B7670000000067253CC5:1407354649/network/default/clients/all'`,
    // ),
    map("equal_sign", "Meh").to$(
      'osascript -e \'tell application "Ghostty" to activate\' && osascript -e \'tell application "System Events" to keystroke "t" using command down\' && osascript -e \'tell application "System Events" to keystroke "simon config keys"\' && osascript -e \'tell application "System Events" to keystroke return\'',
    ),
    map("3", "Meh").to$("open https://ender-3_pro.octoeverywhere.com/"),
  ]);
}

function layer_hyper() {
  return rule("Hyper Layer").manipulators([
    map("h", "Hyper").to("←"),
    map("j", "Hyper").to("↓"),
    map("k", "Hyper").to("↑"),
    map("l", "Hyper").to("→"),
    map("g", "Hyper").to("7", "⌥"), // |
    map("f", "Hyper").to("8", ["⇧", "⌥"]), // {
    map("d", "Hyper").to("8", "⇧"), // (
    map("s", "Hyper").to("8", "⌥"), // [
    map("r", "Hyper").to("9", ["⇧", "⌥"]), // }
    map("e", "Hyper").to("9", "⇧"), // )
    map("w", "Hyper").to("9", "⌥"), // ]
    map("semicolon", "Hyper").to("delete_or_backspace"),
    map("quote", "Hyper").to("delete_forward"),
  ]);
}

function layer_terminal_sessions() {
  return hyperLayer("t")
    .description("Terminal Sessions")
    .leaderMode()
    .notification() // Notification is highly recommanded when use leader mode
    .manipulators({
      j: to$(
        "osascript -e 'tell application \"Ghostty\" to activate' && " +
          'osascript -e \'tell application "System Events" to keystroke "b" using control down\' && ' +
          // 'osascript -e \'tell application "System Events" to keystroke "k" using command down\' && ',
          'osascript -e \'tell application \"System Events\" to keystroke "t"\'',
      ),
    });
}

function layer_symbol() {
  let hint = `\
&   !  @ #    ^   {  [   (  $      ?  }  ]   )  %      _   +      ⌫
N  M  ,   .    H  J  K  L  ;      Y  U  I  O  P       ␣  ⏎      '`;

  let toSymbol = {
    "!": toKey(1, "⇧"),
    "@": toKey(2, "⇧"),
    "#": toKey(3, "⇧"),
    $: toKey(4, "⇧"),
    "%": toKey(5, "⇧"),
    "^": toKey(6, "⇧"),
    "&": toKey(7, "⇧"),
    "*": toKey(8, "⇧"),
    "(": toKey(9, "⇧"),
    ")": toKey(0, "⇧"),
    "|": toKey(5, "option"),
    "[": toKey("["),
    "]": toKey("]"),
    "{": toKey("[", "⇧"),
    "}": toKey("]", "⇧"),

    "-": toKey("-"),
    "=": toKey("="),
    _: toKey("-", "⇧"),
    "+": toKey("=", "⇧"),

    ";": toKey(";"),
    "/": toKey("/"),
    ":": toKey(";", "⇧"),
    "?": toKey("/", "⇧"),

    ",": toKey(","),
    ".": toKey("."),
    "<": toKey(",", "⇧"),
    ">": toKey(".", "⇧"),
  };

  let layer_symbol = layer("").notification(hint);
  return layer_symbol.manipulators([
    withMapper({
      // ! @ # $ % ^ & * ( )    _ +
      // 1 2 3 4 5 6 7 8 9 0    - =

      y: "?",
      u: "}",
      i: "|",
      o: ")", // 0
      p: "%", // 5

      h: "^", // 6
      j: "{",
      k: "[",
      l: "(", // 9
      ";": "$", // 4

      n: "&", // 7
      m: "!", // 1
      ",": "@", // 2
      ".": "#", // 3

      "]": "*", // 8

      "␣": "_",
      "⏎": "+",
    } as const)((k, v) => map(k).to(toSymbol[v])),

    { "'": toKey("⌫") },
  ]);
}

function layer_digitAndDelete() {
  let hint = `\
0    1  2  3    4  5  6    7  8  9    +  -  /  *    .    ⌫_⌥_⌘  ⌦
N   M  ,   .     J  K  L    U  I  O    P  ;   /  ]    [      '   H   Y    \\`;
  let glayer = layer("g").notification(hint);
  return glayer.manipulators([
    // digits keypad_{i}
    withMapper([
      "spacebar", //             // 0
      ...["m", ",", "."], // 1 2 3
      ...["j", "k", "l"], // 4 5 6
      ...["u", "i", "o"], // 7 8 9
    ] as const)((k, i) => map(k).to(`keypad_${i as 0}`)),

    // + - / * .
    {
      p: toKey("=", "⇧"), // +
      ";": toKey("-"), // // -
      // / stay           // /
      right_option: toKey("comma"),

      right_command: toKey("period"),
    },

    // delete ⌫ ⌦
    {
      "\\": toKey("⌦"),

      "'": toKey("⌫"),
      h: toKey("⌫", "⌥"),
      y: toKey("⌫", "⌘"),
    },

    // F1 - F9
    withMapper([1, 2, 3, 4, 5, 6, 7, 8, 9])((k) => map(k).to(`f${k}`)),
  ]);
}

function layer_snippet() {
  return duoLayer("z", "x").manipulators([
    { 2: toPaste("⌫"), 3: toPaste("⌦"), 4: toPaste("⇥"), 5: toPaste("⎋") },
    { 6: toPaste("⌘"), 7: toPaste("⌥"), 8: toPaste("⌃"), 9: toPaste("⇧") },
    { 0: toPaste("⇪"), ",": toPaste("‹"), ".": toPaste("›") },

    withMapper(["←", "→", "↑", "↓", "␣", "⏎", "⌫", "⌦"])((k) =>
      map(k).toPaste(k),
    ),

    withCondition(ifApp("^com.microsoft.VSCode$"))([
      map("k").to("f20").to("k"),
      map("l").to("f20").to("l"),
    ]),
    withCondition(ifApp("^com.jetbrains.WebStorm$"))([
      map("k").toTypeSequence("afun"),
    ]),
    map("k").toTypeSequence("()␣=>␣"),
    map("l").toTypeSequence("console.log()←"),
    map("o").toTypeSequence("console.assert()←"),
    map("/").toTypeSequence("cn()←"),

    map("'").toTypeSequence('⌫"'),
    map("[").toTypeSequence("[␣]␣"),
    map("]").toTypeSequence("-␣[␣]␣"),

    { "'": toKey("⌫"), "\\": toKey("⌦") },
  ]);
}

function layer_launchApp() {
  let appLayer = duoLayer("semicolon", "l").notification("Öppna App 🚀 📱");
  return appLayer.manipulators({
    // a: toApp("ChatGPT"), // AI
    // b: toApp("Safari"), // Browser
    c: toApp("Calendar"),
    // d: toApp("Eudb_en"), // Dictionary
    // e: toApp("Zed"), // Editor
    f: toApp("Finder"),
    g: toApp("Grok"),
    h: toApp("Home Assistant"),
    j: toApp("Ghostty"), // IM
    // m: toApp("Spark Desktop"), // Mail
    // r: to$(`open ~/Applications/Rider.app`),
    k: toApp("Google Chrome"),
    n: toApp("Notion"),
    // t: toApp("Warp"), // Terminal
    s: toApp("Spotify"), // mUsic
    v: toApp("Visual Studio Code"),
    // w: to$(`open ~/Applications/WebStorm.app`),
    // y: to$(String.raw`open ~/Applications/PyCharm\ Professional\ Edition.app`),
    // z: toApp("zoom.us"),

    ",": toApp("System Settings"),
  });
}

function layer_openLink() {
  let linkLayer = duoLayer("period", "slash").notification("Öppna länk 🔗");
  const openLink = (url: string) => to$(`open '${url}'`);

  return linkLayer.manipulators({
    x: openLink("https://www.x.com"),
    f: openLink("https://www.facebook.com"),
    g: openLink("https://github.com/simonbrundin?tab=repositories"),
    y: openLink("https://www.youtube.com"),
    s: openLink("https://www.spotify.com"),
    u: openLink(
      "https://unifi.ui.com/consoles/0CEA145690E500000000087652220000000008E9B7670000000067253CC5:1407354649/network/default/clients/all",
    ),
  });
}

// function layer_system() {
//   return layer("`", "system").manipulators({
//     1: toMouseCursorPosition({ x: "25%", y: "50%", screen: 0 }),
//     2: toMouseCursorPosition({ x: "50%", y: "50%", screen: 0 }),
//     3: toMouseCursorPosition({ x: "75%", y: "50%", screen: 0 }),
//     4: toMouseCursorPosition({ x: "99%", y: 20, screen: 0 }),

//     5: toMouseCursorPosition({ x: "50%", y: "50%", screen: 1 }),

//     "⏎": toPointingButton("button1"),

//     n: toClearNotifications,

//     "␣": toSleepSystem(),

//     j: toKey("⇥", "⌘"),
//     k: toKey("⇥", "⌘⇧"),
//   });
// }

// function app_chrome() {
//   return rule("Chrome", ifApp("^com.google.Chrome$")).manipulators([
//     ...historyNavi(),
//     ...tabNavi(),
//     ...switcher(),

//     ...tapModifiers({
//       "‹⌥": toKey("r", "⌘"), // refreshThePage

//       "›⌘": toKey("i", "⌘⌥"), // developerTools
//       "›⌥": toKey("a", "⌘⇧"), // searchTabs
//     }),

//     map(1, "Meh").to(toResizeWindow("Google Chrome")),
//   ]);
// }

function app_ghostty() {
  return rule("Ghostty", ifApp("^com.mitchellh.ghostty$")).manipulators([
    map("k", "command").to$(
      'osascript -e \'tell application "System Events" to keystroke "c" using control down\' && ' +
        'osascript -e \'tell application "System Events" to keystroke "clear"\' && ' +
        // 'osascript -e \'tell application "System Events" to keystroke "k" using command down\' && ',
        "osascript -e 'tell application \"System Events\" to key code 36'",
    ),
  ]);
}
// function app_safari() {
//   return rule("Safari", ifApp("^com.apple.Safari$")).manipulators([
//     ...historyNavi(),
//     ...tabNavi(),
//     ...switcher(),

//     ...tapModifiers({
//       "‹⌘": toKey("l", "⌘⇧"), // showHideSideBar
//       "‹⌥": toKey("r", "⌘"), // reloadPage

//       "›⌘": toKey("i", "⌘⌥"), // showWebInspector
//     }),

//     map(1, "Meh").to(toResizeWindow("Safari")),
//   ]);
// }

// function app_jetBrainsIDE() {
//   return rule("JetBrains IDE", ifApp("^com.jetbrains.[\\w-]+$")).manipulators([
//     ...historyNavi(),
//     ...tabNavi(),
//     ...switcher(),

//     ...tapModifiers({
//       "‹⌘": toKey("⎋", "⌘⇧"), // hideAllToolWindows
//       "‹⌥": toKey("r", "⌥⇧"), // Run
//       "‹⌃": toKey("r", "⌥⌃"), // Run...

//       "›⌘": toKey(4, "⌥"), // toolWindows_terminal
//       "›⌥": toKey("a", "⌘⇧"), // findAction
//       "›⌃": toKey("e", "⌘"), // recentFiles
//     }),

//     map(1, "Meh").to(toResizeWindow("WebStorm")),
//   ]);
// }

// function app_zed() {
//   return rule("Zed", ifApp("^dev.zed.Zed$")).manipulators([
//     ...historyNavi(),
//     ...tabNavi(),
//     ...switcher(),

//     ...tapModifiers({
//       "‹⌘": toKey("y", "⌘⌥"), // closeAllDocks
//       "‹⌥": toKey("t", "⌥"), // task::Rerun
//       "‹⌃": toKey("t", "⌥⇧"), // task::Spawn

//       "›⌘": toKey("`", "⌃"), // terminal
//       "›⌥": toKey("a", "⌘⇧"), // command
//       "›⌃": toKey("p", "⌘"), // fileFinder
//     }),

//     map(1, "Meh").to(toResizeWindow("Zed")),
//   ]);
// }

// function app_vsCode() {
//   return rule("VSCode", ifApp("^com.microsoft.VSCode$")).manipulators([
//     ...tabNavi(),
//     ...switcher(),
//     map("h", "⌃").to("-", "⌃"),
//     map("l", "⌃").to("-", "⌃⇧"),

//     ...tapModifiers({
//       "‹⌘": toKey("⎋", "⌘"), // Tobble Sidebar visibility
//       "‹⌥": toKey("r", "⌥⇧"), // Run

//       "›⌘": toKey("`", "⌃"), // terminal
//       "›⌥": toKey("p", "⌘⇧"), // Show Command Palette
//       "›⌃": toKey("p", "⌘"), // Quick Open, Go to File...
//     }),

//     map(1, "Meh").to(toResizeWindow("Code")),
//   ]);
// }

// function app_cursor() {
//   return rule("Cursor", ifApp("^com.todesktop.230313mzl4w4u92$")).manipulators([
//     ...tabNavi(),
//     ...switcher(),
//     map("h", "⌃").to("-", "⌃"),
//     map("l", "⌃").to("-", "⌃⇧"),

//     ...tapModifiers({
//       "‹⌘": toKey("⎋", "⌘"), // Tobble Sidebar visibility
//       "‹⌥": toKey("r", "⌥⇧"), // Run

//       "›⌘": toKey("`", "⌃"), // terminal
//       "›⌥": toKey("p", "⌘⇧"), // Show Command Palette
//       "›⌃": toKey("p", "⌘"), // Quick Open, Go to File...
//     }),
//   ]);
// }

// function app_warp() {
//   return rule("Warp", ifApp("^dev.warp.Warp")).manipulators([
//     ...tabNavi(),
//     map(1, "Meh").to(toResizeWindow("Warp")),
//   ]);
// }

// function app_slack() {
//   return rule("Slack", ifApp("^com.tinyspeck.slackmacgap$")).manipulators([
//     ...historyNavi(),

//     ...tapModifiers({
//       "‹⌘": toKey("d", "⌘⇧"), // showHideSideBar
//       "‹⌥": toKey("f6"), // moveFocusToTheNextSection

//       "›⌘": toKey(".", "⌘"), // hideRightBar
//       "›⌥": toKey("k", "⌘"), // open
//     }),

//     map(1, "Meh").to(
//       // After the 1/4 width, leave some space for opening thread in a new window
//       // before the last 1/4 width
//       toResizeWindow("Slack", { x: 1263, y: 25 }, { w: 1760, h: 1415 })
//     ),
//   ]);
// }

// function app_spark() {
//   return rule("Spark", ifApp("^com.readdle.SparkDesktop")).manipulators([
//     ...tapModifiers({
//       "‹⌘": toKey("/"), // openSidebar
//       "‹⌥": toKey("r", "⌘"), // fetch

//       "›⌘": toKey("/", "⌘"), // changeLayout
//       "›⌥": toKey("k", "⌘"), // actions
//     }),

//     map(1, "Meh").to(
//       toResizeWindow("Spark Desktop", undefined, { w: 1644, h: 1220 })
//     ),
//   ]);
// }

// function app_zoom() {
//   return rule("Zoom", ifApp("^us.zoom.xos$")).manipulators(
//     tapModifiers({
//       "‹⌘": toKey("a", "⌘⇧"), // muteUnmuteMyAudio
//       "‹⌥": toKey("s", "⌘⇧"), // startStopScreenSharing

//       "›⌘": toKey("v", "⌘⇧"), // startStopVideo
//       "›⌥": toKey("h", "⌘⇧"), // showHideChatPanel
//     })
//   );
// }

// function app_raycast() {
//   return rule("Raycast").manipulators([
//     map("␣", "⌥").to(raycastExt("evan-liu/quick-open/index")),

//     withModifier("Hyper")({
//       "↑": raycastWin("previous-display"),
//       "↓": raycastWin("next-display"),
//       "←": raycastWin("previous-desktop"),
//       "→": raycastWin("next-desktop"),
//     }),
//     withModifier("Hyper")({
//       1: raycastWin("first-third"),
//       2: raycastWin("center-third"),
//       3: raycastWin("last-third"),
//       4: raycastWin("first-two-thirds"),
//       5: raycastWin("last-two-thirds"),
//       9: raycastWin("left-half"),
//       0: raycastWin("right-half"),
//     }),
function app_homerow() {
  return rule("Homerow").manipulators([
    mapSimultaneous(["f", "j"]).to("␣", "Hyper"), // Click
    mapSimultaneous(["f", "k"]).to("⏎", "Hyper"), // Scroll
    mapSimultaneous(["f", "l"]).to("hyphen", "Hyper"), // Scroll
  ]);
}
//     withModifier("Meh")({
//       1: raycastWin("first-fourth"),
//       2: raycastWin("second-fourth"),
//       3: raycastWin("third-fourth"),
//       4: raycastWin("last-fourth"),
//       5: raycastWin("center"),
//       6: raycastWin("center-half"),
//       7: raycastWin("center-two-thirds"),
//       8: raycastWin("maximize"),
//     }),
//   ]);
// }

// function app_chatGPT() {
//   return rule("ChatGPT", ifApp("^com.openai.chat$")).manipulators([
//     map(1, "Meh").to(toResizeWindow("ChatGPT")),
//   ]);
// }

// function keyboard_apple() {
//   let ifAppleKeyboard = ifDevice({ vendor_id: 12951 }).unless(); // Not Moonlander
//   return rule("Apple Keyboard", ifAppleKeyboard).manipulators([
//     map("⇪", "?⌘⌃").to("⎋"),
//     map("⇪", "⇧").to("g⇪"),

//     map("›⌥", "›⇧").toHyper(),
//     map("›⌘", "›⇧").toMeh(),
//   ]);
// }

// function keyboard_moonlander() {
//   let ifMoonlander = ifDevice({ vendor_id: 12951, product_id: 6505 });
//   return rule("Moonlander", ifMoonlander).manipulators([
//     map("⎋", "⇧").to("⇪"),
//     map("⎋", "⇪").to("⇪"),

//     ...tapModifiers({
//       "‹⌃": toKey("␣", "⌘⇧"), // selectNextSourceInInputMenu
//     }),
//   ]);
// }

main();

return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false,
  opts = {
    providers = {
      grok = {
        endpoint = "https://api.x.ai/v1/chat/completions",
        model = "grok-2-latest",
        parse_curl_args = function(opts, code_opts)
          local curl_args = {
            url = opts.endpoint,
            headers = {
              ["Content-Type"] = "application/json",
            },
            body = {
              model = opts.model,
              messages = code_opts.messages or { { role = "user", content = code_opts.question } },
              stream = true,
            },
            extra_curl_options = {
              "--no-buffer",
              "-N",
              "--connect-timeout",
              "10",
              "--max-time",
              "60", -- Öka till 60 sekunder
              "-v", -- Verbose output för att se curl-detaljer
            },
          }
          print(
            "Curl-kommando: curl -X POST "
              .. curl_args.url
              .. ' -H "Authorization: Bearer [dold]" -H "Content-Type: application/json" -d \''
              .. vim.json.encode(curl_args.body)
              .. "' "
              .. table.concat(curl_args.extra_curl_options or {}, " ")
          )
          return curl_args
        end,
        parse_response = function(data_stream, event_state, opts)
          if not data_stream then
            print("Ingen dataström mottagen från API:et")
            return
          end
          print("Rå dataström: " .. vim.inspect(data_stream))
          local json_str = type(data_stream) == "table" and table.concat(data_stream, "") or data_stream
          print("Efter table.concat: " .. json_str)
          json_str = json_str:gsub("^data: ", ""):gsub("^%s*$", "")
          print("Efter gsub: " .. json_str)
          if json_str == "" then
            print("Tom JSON-sträng efter bearbetning")
            return
          end
          local ok, json = pcall(vim.json.decode, json_str)
          if not ok then
            print("Misslyckades med att avkoda JSON: " .. json_str)
            return
          end
          if
            json.choices
            and json.choices[0]
            and json.choices[0].delta
            and json.choices[0].delta.content
            and opts
            and opts.on_chunk
          then
            opts.on_chunk(json.choices[0].delta.content)
          else
            print("Ovälntat svarformat: " .. vim.inspect(json))
            return
          end
          if event_state == "done" and opts and opts.on_complete then
            opts.on_complete()
          end
        end,
      },
      openai = {
        endpoint = "https://api.openai.com/v1",
        model = "gpt-4o",
        timeout = 30000,
        extra_request_body = {
          temperature = 0,
          max_tokens = 4096,
        },
      },
    },
  },
  build = "make",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-mini/mini.pick",
    "nvim-telescope/telescope.nvim",
    "hrsh7th/nvim-cmp",
    "ibhagwan/fzf-lua",
    "nvim-tree/nvim-web-devicons",
    "zbirenbaum/copilot.lua",
    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          use_absolute_path = true,
        },
      },
    },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}

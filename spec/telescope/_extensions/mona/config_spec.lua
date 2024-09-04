describe("telescope._extensions.mona.config", function()
  local config = require("telescope._extensions.mona.config")

  before_each(function()
    config.reset()
  end)

  describe("setup", function()
    describe("merging user config with the user extension config", function()
      it("should extend exisiting dictionaries on key collision", function()
        config.values = {
          pickers = {
            [config.included_pickers_name] = {
              theme = "dropdown",
            },
          },
        }

        local user_config = {
          extensions = {
            mona = {
              dictionary = {
                user_config_value = "a user config value",
              },
            },
          },
        }

        local user_extension_config = {
          extensions = {
            mona = {
              dictionary = {
                user_extension_config_value = "a user extension config value",
              },
            },
          },
        }

        local expected_result = {
          pickers = {
            [config.included_pickers_name] = {
              theme = "dropdown",
            },
          },

          extensions = {
            mona = {
              dictionary = {
                user_config_value = "a user config value",
                user_extension_config_value = "a user extension config value",
              },
            },
          },
        }

        local result = config.setup(user_extension_config, user_config).values

        assert.same(expected_result, result)
      end)

      it(
        "should replace exisiting primitive values on key collision",
        function()
          config.values = {
            pickers = {
              [config.included_pickers_name] = {
                theme = "dropdown",
              },
            },
          }

          local user_config = {
            extensions = {
              mona = {
                string = "a user config string value",
                integer = 1,
                boolean = false,

                array = {
                  "a user config array value",
                },
              },
            },
          }

          local user_extension_config = {
            extensions = {
              mona = {
                string = "a extension config string value",
                integer = 2,
                boolean = true,

                array = {
                  "a extension config array value",
                },
              },
            },
          }

          local expected_result = {
            pickers = {
              [config.included_pickers_name] = {
                theme = "dropdown",
              },
            },

            extensions = {
              mona = {
                string = "a extension config string value",
                integer = 2,
                boolean = true,

                array = {
                  "a extension config array value",
                },
              },
            },
          }

          local result = config.setup(user_extension_config, user_config).values

          assert.same(expected_result, result)
        end
      )

      it("should merge values from the user config on key missing", function()
        config.values = {
          pickers = {
            [config.included_pickers_name] = {
              theme = "dropdown",
            },
          },
        }

        local user_config = {
          user_config_value = "a user config value",

          extensions = {
            mona = {
              user_config_value = "a user config value",
            },
          },
        }

        local user_extension_config = {
          extensions = {
            mona = {},
          },
        }

        local expected_result = {
          pickers = {
            [config.included_pickers_name] = {
              theme = "dropdown",
            },
          },

          user_config_value = "a user config value",

          extensions = {
            mona = {
              user_config_value = "a user config value",
            },
          },
        }

        local result = config.setup(user_extension_config, user_config).values

        assert.same(expected_result, result)
      end)

      it(
        "should preserve values from the user extension config on key missing",
        function()
          config.values = {
            pickers = {
              [config.included_pickers_name] = {
                theme = "dropdown",
              },
            },
          }

          local user_config = {
            extensions = {
              mona = {},
            },
          }

          local user_extension_config = {
            user_extension_config_value = "a user extension config value",

            extensions = {
              mona = {
                user_extension_config_value = "a user extension config value",
              },
            },
          }

          local expected_result = {
            pickers = {
              [config.included_pickers_name] = {
                theme = "dropdown",
              },
            },

            user_extension_config_value = "a user extension config value",

            extensions = {
              mona = {
                user_extension_config_value = "a user extension config value",
              },
            },
          }

          local result = config.setup(user_extension_config, user_config).values

          assert.same(expected_result, result)
        end
      )
    end)

    it("should be persisted", function()
      config.values = {
        pickers = {
          [config.included_pickers_name] = {
            theme = "dropdown",
          },
        },
      }

      local user_config = {
        extensions = {
          mona = {
            user_config_value = "a user config value",
          },
        },
      }

      local user_extension_config = {
        extensions = {
          mona = {
            user_extension_config_value = "a user extension config value",
          },
        },
      }

      config.setup(user_extension_config, user_config)

      local expected_result = {
        pickers = {
          [config.included_pickers_name] = {
            theme = "dropdown",
          },
        },

        extensions = {
          mona = {
            user_config_value = "a user config value",
            user_extension_config_value = "a user extension config value",
          },
        },
      }

      local result = require("telescope._extensions.mona.config").values

      assert.same(expected_result, result)
    end)
  end)

  describe("merge", function()
    describe(
      "merging config with the picker config, theme config and picker opts",
      function()
        it("should extend exisiting dictionaries on key collision", function()
          config.values = {
            extensions = {
              mona = {
                dictionary = {
                  picker_config_value = "a picker config value",
                },
              },
            },

            pickers = {
              [config.included_pickers_name] = {
                theme = "dropdown",
              },
            },
          }

          local picker_opts = {
            picker_name = config.included_pickers_name,

            extensions = {
              mona = {
                dictionary = {
                  picker_opts_value = "a picker opts value",
                },
              },
            },
          }

          local expected_result = {
            picker_name = config.included_pickers_name,

            extensions = {
              mona = {
                dictionary = {
                  picker_config_value = "a picker config value",
                  picker_opts_value = "a picker opts value",
                },
              },
            },

            pickers = {
              [config.included_pickers_name] = {
                theme = "dropdown",
              },
            },
          }

          local result = config.merge(picker_opts)

          assert.same(expected_result.picker_name, result.picker_name)
          assert.same(expected_result.extensions, result.extensions)
          assert.same(expected_result.pickers, result.pickers)

          assert.same(
            expected_result.pickers[config.included_pickers_name].theme,
            result.theme
          )

          assert.truthy(result.border)
          assert.truthy(result.borderchars)
          assert.truthy(result.borderchars.preview)
          assert.truthy(result.borderchars.prompt)
          assert.truthy(result.borderchars.results)
          assert.truthy(result.borderchars.results)
          assert.truthy(result.layout_config)
          assert.truthy(result.layout_config.height)
          assert.truthy(result.layout_config.preview_cutoff)
          assert.truthy(result.layout_config.width)
          assert.truthy(result.layout_strategy)
          assert.truthy(result.sorting_strategy)
          assert.truthy(result.theme)
        end)

        it(
          "should replace exisiting primitive values on key collision",
          function()
            config.values = {
              extensions = {
                mona = {
                  string = "a picker config string value",
                  integer = 1,
                  boolean = false,

                  array = {
                    "a picker config array value",
                  },
                },
              },

              pickers = {
                [config.included_pickers_name] = {
                  theme = "dropdown",
                },
              },
            }

            local picker_opts = {
              picker_name = config.included_pickers_name,

              extensions = {
                mona = {
                  string = "a picker opts string value",
                  integer = 2,
                  boolean = true,

                  array = {
                    "a picker opts array value",
                  },
                },
              },
            }

            local expected_result = {
              picker_name = config.included_pickers_name,

              extensions = {
                mona = {
                  string = "a picker opts string value",
                  integer = 2,
                  boolean = true,

                  array = {
                    "a picker opts array value",
                  },
                },
              },

              pickers = {
                [config.included_pickers_name] = {
                  theme = "dropdown",
                },
              },
            }

            local result = config.merge(picker_opts)

            assert.same(expected_result.picker_name, result.picker_name)
            assert.same(expected_result.extensions, result.extensions)
            assert.same(expected_result.pickers, result.pickers)

            assert.same(
              expected_result.pickers[config.included_pickers_name].theme,
              result.theme
            )

            assert.truthy(result.border)
            assert.truthy(result.borderchars)
            assert.truthy(result.borderchars.preview)
            assert.truthy(result.borderchars.prompt)
            assert.truthy(result.borderchars.results)
            assert.truthy(result.borderchars.results)
            assert.truthy(result.layout_config)
            assert.truthy(result.layout_config.height)
            assert.truthy(result.layout_config.preview_cutoff)
            assert.truthy(result.layout_config.width)
            assert.truthy(result.layout_strategy)
            assert.truthy(result.sorting_strategy)
            assert.truthy(result.theme)
          end
        )

        it(
          "should merge values from the picker config on key missing",
          function()
            config.values = {
              picker_config_value = "a picker config value",

              extensions = {
                mona = {
                  picker_config_value = "a picker config value",
                },
              },

              pickers = {
                [config.included_pickers_name] = {
                  theme = "dropdown",
                },
              },
            }

            local picker_opts = {
              picker_name = config.included_pickers_name,

              extensions = {
                mona = {},
              },
            }

            local expected_result = {
              picker_config_value = "a picker config value",

              picker_name = config.included_pickers_name,

              extensions = {
                mona = {
                  picker_config_value = "a picker config value",
                },
              },

              pickers = {
                [config.included_pickers_name] = {
                  theme = "dropdown",
                },
              },
            }

            local result = config.merge(picker_opts)

            assert.same(expected_result.picker_name, result.picker_name)
            assert.same(expected_result.extensions, result.extensions)
            assert.same(expected_result.pickers, result.pickers)

            assert.same(
              expected_result.pickers[config.included_pickers_name].theme,
              result.theme
            )

            assert.truthy(result.border)
            assert.truthy(result.borderchars)
            assert.truthy(result.borderchars.preview)
            assert.truthy(result.borderchars.prompt)
            assert.truthy(result.borderchars.results)
            assert.truthy(result.borderchars.results)
            assert.truthy(result.layout_config)
            assert.truthy(result.layout_config.height)
            assert.truthy(result.layout_config.preview_cutoff)
            assert.truthy(result.layout_config.width)
            assert.truthy(result.layout_strategy)
            assert.truthy(result.sorting_strategy)
            assert.truthy(result.theme)
          end
        )

        it(
          "should preserve values from the picker opts on key missing",
          function()
            config.values = {
              pickers = {
                [config.included_pickers_name] = {
                  theme = "dropdown",
                },
              },
            }

            local picker_opts = {
              picker_opts_value = "a picker opts value",

              picker_name = config.included_pickers_name,

              extensions = {
                mona = {
                  picker_opts_value = "a picker opts value",
                },
              },
            }

            local expected_result = {
              picker_opts_value = "a picker opts value",

              picker_name = config.included_pickers_name,

              extensions = {
                mona = {
                  picker_opts_value = "a picker opts value",
                },
              },

              pickers = {
                [config.included_pickers_name] = {
                  theme = "dropdown",
                },
              },
            }

            local result = config.merge(picker_opts)

            assert.same(expected_result.picker_name, result.picker_name)
            assert.same(expected_result.extensions, result.extensions)
            assert.same(expected_result.pickers, result.pickers)

            assert.same(
              expected_result.pickers[config.included_pickers_name].theme,
              result.theme
            )

            assert.truthy(result.border)
            assert.truthy(result.borderchars)
            assert.truthy(result.borderchars.preview)
            assert.truthy(result.borderchars.prompt)
            assert.truthy(result.borderchars.results)
            assert.truthy(result.borderchars.results)
            assert.truthy(result.layout_config)
            assert.truthy(result.layout_config.height)
            assert.truthy(result.layout_config.preview_cutoff)
            assert.truthy(result.layout_config.width)
            assert.truthy(result.layout_strategy)
            assert.truthy(result.sorting_strategy)
            assert.truthy(result.theme)
          end
        )

        it(
          "should merge a theme config using the theme set on the picker config",
          function()
            config.values = {
              theme = "dropdown",
            }

            local picker_opts = {
              picker_name = config.included_pickers_name,
            }

            local result = config.merge(picker_opts)

            assert.equals(result.theme, "dropdown")

            assert.truthy(result.border)
            assert.truthy(result.borderchars)
            assert.truthy(result.borderchars.preview)
            assert.truthy(result.borderchars.prompt)
            assert.truthy(result.borderchars.results)
            assert.truthy(result.borderchars.results)
            assert.truthy(result.layout_config)
            assert.truthy(result.layout_config.height)
            assert.truthy(result.layout_config.preview_cutoff)
            assert.truthy(result.layout_config.width)
            assert.truthy(result.layout_strategy)
            assert.truthy(result.sorting_strategy)
          end
        )

        it(
          "should merge a theme config using the theme set on the picker config",
          function()
            config.values = {
              theme = "dropdown",

              pickers = {
                [config.included_pickers_name] = {
                  theme = "ivy",
                },
              },
            }

            local picker_opts = {
              picker_name = config.included_pickers_name,
            }

            local result = config.merge(picker_opts)

            assert.equals(result.theme, "ivy")

            assert.truthy(result.border)
            assert.truthy(result.borderchars)
            assert.truthy(result.borderchars.preview)
            assert.truthy(result.borderchars.prompt)
            assert.truthy(result.borderchars.results)
            assert.truthy(result.borderchars.results)
            assert.truthy(result.layout_config)
            assert.truthy(result.layout_config.height)
            assert.truthy(result.layout_strategy)
            assert.truthy(result.sorting_strategy)
          end
        )

        it(
          "should merge a theme config using the theme set on the picker opts",
          function()
            config.values = {
              theme = "dropdown",

              pickers = {
                [config.included_pickers_name] = {
                  theme = "ivy",
                },
              },
            }

            local picker_opts = {
              picker_name = config.included_pickers_name,

              theme = "cursor",
            }

            local result = config.merge(picker_opts)

            assert.equals(result.theme, "cursor")

            assert.truthy(result.borderchars)
            assert.truthy(result.borderchars.preview)
            assert.truthy(result.borderchars.prompt)
            assert.truthy(result.borderchars.results)
            assert.truthy(result.borderchars.results)
            assert.truthy(result.layout_config)
            assert.truthy(result.layout_config.height)
            assert.truthy(result.layout_config.width)
            assert.truthy(result.layout_strategy)
            assert.truthy(result.sorting_strategy)
          end
        )

        it(
          "should not merge a theme config if the picker name is not set on the picker opts",
          function()
            config.values = {}

            local picker_opts = {}

            local result = config.merge(picker_opts)

            assert.falsy(result.picker_name)
            assert.falsy(result.border)
            assert.falsy(result.borderchars)
            assert.falsy(result.layout_config)
            assert.falsy(result.layout_strategy)
            assert.falsy(result.sorting_strategy)
            assert.falsy(result.theme)
          end
        )

        it(
          "should not merge a theme config if a theme is not set on the picker config or picker opts",
          function()
            config.values = {}

            local picker_opts = {
              picker_name = config.included_pickers_name,
            }

            local expected_result = {
              picker_name = config.included_pickers_name,
            }

            local result = config.merge(picker_opts)

            assert.same(expected_result.picker_name, result.picker_name)

            assert.falsy(result.border)
            assert.falsy(result.borderchars)
            assert.falsy(result.layout_config)
            assert.falsy(result.layout_strategy)
            assert.falsy(result.sorting_strategy)
            assert.falsy(result.theme)
          end
        )
      end
    )

    it("should not be persisted", function()
      config.values = {
        pickers = {
          [config.included_pickers_name] = {
            theme = "dropdown",
          },
        },
      }

      local picker_opts = {
        picker_name = config.included_pickers_name,

        extensions = {
          mona = {
            picker_opts_value = "a picker opts value",
          },
        },
      }

      config.merge(picker_opts)

      local expected_result = {
        pickers = {
          [config.included_pickers_name] = {
            theme = "dropdown",
          },
        },
      }

      local result = require("telescope._extensions.mona.config").values

      assert.same(expected_result, result)
    end)
  end)

  describe("register_included_pickers", function()
    it("should register a picker", function()
      local pickers = {
        ["picker name"] = function()
          return "picker function"
        end,
      }

      config.register_included_pickers(pickers)

      local expected_picker_name = config.included_pickers[1][1]

      local expected_picker = config.included_pickers[1][2]()

      assert.equals(expected_picker_name, "picker name")
      assert.equals(expected_picker, "picker function")
    end)

    it("should not register the included pickers picker", function()
      local pickers = {
        [config.included_pickers_name] = function()
          return "picker function"
        end,
      }

      config.register_included_pickers(pickers)

      assert.same({}, config.included_pickers)
    end)

    it("should be persisted", function()
      local pickers = {
        ["picker name"] = function()
          return "picker function"
        end,
      }

      config.register_included_pickers(pickers)

      config = require("telescope._extensions.mona.config")

      local expected_picker_name = config.included_pickers[1][1]

      local expected_picker = config.included_pickers[1][2]()

      assert.equals(expected_picker_name, "picker name")
      assert.equals(expected_picker, "picker function")
    end)
  end)

  describe("reset", function()
    it("should reset persisted config", function()
      config.values = {
        pickers = {
          [config.included_pickers_name] = {
            theme = "ivy",
          },
        },
      }

      local user_config = {
        extensions = {
          mona = {
            user_config_value = "a user config value",
          },
        },
      }

      local user_extension_config = {
        extensions = {
          mona = {
            user_extension_config_value = "a user extension config value",
          },
        },
      }

      config.setup(user_extension_config, user_config)

      local expected_result = {
        pickers = {
          [config.included_pickers_name] = {
            theme = "dropdown",
          },
        },
      }

      config = require("telescope._extensions.mona.config")

      config.reset()

      local result = config.values

      assert.same(expected_result, result)
    end)
  end)
end)

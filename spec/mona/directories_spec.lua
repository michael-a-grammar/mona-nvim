describe("mona.directories", function()
  local directories = require("mona.directories")

  local current_working_directory = vim.fn.getcwd()

  local mona_test_project_directory = current_working_directory
    .. "/test_projects/mona_test_project"

  local mona_test_umbrella_project_directory = current_working_directory
    .. "/test_projects/mona_test_umbrella_project"

  describe("project", function()
    it("should return the elixir project directory", function()
      local expected_project_directory = mona_test_project_directory

      vim.api.nvim_set_current_dir(mona_test_project_directory .. "/lib")

      local project_directory = directories.project()

      assert.equals(expected_project_directory, project_directory)
    end)
  end)

  describe("application", function()
    it("should return the current application directory", function()
      vim.api.nvim_set_current_dir(mona_test_umbrella_project_directory)

      vim.cmd("edit apps/mona_test_application1/lib/mona_test_application1.ex")

      local expected_application_directory = mona_test_umbrella_project_directory
        .. "/apps/mona_test_application1"

      local application_directory = directories.application()

      assert.equals(expected_application_directory, application_directory)
    end)

    it("should not return an application directory", function()
      vim.api.nvim_set_current_dir(mona_test_project_directory)

      vim.cmd("edit lib/mona_test_project.ex")

      local expected_application_directory = false

      local application_directory = directories.application()

      assert.equals(expected_application_directory, application_directory)
    end)
  end)

  describe("buffer", function()
    it("should return the current buffer directory", function()
      vim.api.nvim_set_current_dir(mona_test_project_directory)

      local expected_buffer_directory = mona_test_project_directory .. "/lib"

      vim.cmd("edit lib/mona_test_project.ex")

      local buffer_directory = directories.buffer()

      assert.equals(expected_buffer_directory, buffer_directory)
    end)
  end)
end)

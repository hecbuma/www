require "capistrano/scm"
require "capistrano/git"

module Capistrano
  class Git < Capistrano::SCM
    module CustomStrategy
      include DefaultStrategy

      def clone
        if (depth = fetch(:git_shallow_clone))
          git(
            :clone,
            "--depth",
            depth,
            "--no-single-branch",
            repo_url,
            repo_path
          )
        else
          git :clone, repo_url, repo_path
        end
      end

      def update
        branch = fetch(:branch)
        if (depth = fetch(:git_shallow_clone))
          git :fetch, "--depth", depth, "origin", branch
        else
          git :checkout, branch

          git :pull
        end
      end

      def checkout
        git :checkout, fetch(:branch)[]
      end
    end
  end
end

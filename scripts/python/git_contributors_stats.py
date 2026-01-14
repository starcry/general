import collections
import sys
import os
import git
from dateutil.relativedelta import relativedelta

# Configuration
EXCLUDED_FILES = ['Jenkinsfile']
EXCLUDED_EXTENSIONS = ['.hcl']

# Function to find the .git directory
def find_git_root(path):
    while path != '/':
        if os.path.isdir(os.path.join(path, '.git')):
            return path
        path = os.path.dirname(path)
    raise git.exc.InvalidGitRepositoryError(f"Cannot find a .git directory at or above {path}")

# Get the repository path from the current working directory
def get_current_repo_path():
    current_dir = os.getcwd()
    return find_git_root(current_dir)

repo_path = get_current_repo_path()
os.chdir(repo_path)

# Initialize Git repository
repo = git.Repo(repo_path)

# Get the date one year ago from the last commit
def get_date_one_year_ago():
    last_commit_date = repo.head.commit.committed_datetime
    one_year_ago = last_commit_date - relativedelta(years=1)
    return one_year_ago.date()

# Get all commits from the past year
def get_commits_from_past_year(since_date):
    commits = list(repo.iter_commits(since=since_date))
    return commits

# Get the number of commits in the past year
def get_commit_count():
    since_date = get_date_one_year_ago()
    commits = get_commits_from_past_year(since_date)
    return len(commits)

# Get the last commit date
def get_last_commit_date():
    last_commit_date = repo.head.commit.committed_datetime
    return last_commit_date.date()

# Get the stats for each commit
def get_commit_stats(commit):
    files_changed = commit.stats.files.keys()
    filtered_files = [f for f in files_changed if not any(f.endswith(ext) for ext in EXCLUDED_EXTENSIONS) and f not in EXCLUDED_FILES]
    lines_changed = sum(commit.stats.files[f]['insertions'] + commit.stats.files[f]['deletions'] for f in filtered_files)
    files_changed_count = len(filtered_files)
    return lines_changed, files_changed_count

# Get the top contributors
def print_top_contributors():
    one_year_ago = get_date_one_year_ago()
    commits = get_commits_from_past_year(one_year_ago)
    contributors = collections.defaultdict(lambda: {'lines': 0, 'files': 0})

    for commit in commits:
        author = commit.author.email
        lines_changed, files_changed_count = get_commit_stats(commit)
        contributors[author]['lines'] += lines_changed
        contributors[author]['files'] += files_changed_count

    top_lines = sorted(contributors.items(), key=lambda x: x[1]['lines'], reverse=True)[:2]
    top_files = sorted(contributors.items(), key=lambda x: x[1]['files'], reverse=True)[:2]

    print("\nTop 2 contributors by lines changed:")
    for author, stats in top_lines:
        print(f"{author}: {stats['lines']} lines")

    print("\nTop 2 contributors by files changed:")
    for author, stats in top_files:
        print(f"{author}: {stats['files']} files")

if __name__ == "__main__":
    # Get commit stats and last commit date
    commit_count = get_commit_count()
    last_commit_date = get_last_commit_date()

    # Always print commit stats
    print(f"Date of the last commit: {last_commit_date}")
    print(f"Number of commits in the past year: {commit_count}")

    # Print top contributors
    print_top_contributors()


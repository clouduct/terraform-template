# Clouduct - Terraform Template


## Prerequisites
You need your aws credentials as environment variables or as a profile in `~/.aws/credentials`.
Export the environment variable AWS_PROFILE to the name of the profile containing your access keys.

For now, change the project name in `.clouduct-tf` to avoid conflicts with other developers, e.g. add your own initials.

### Bootstrap
```
./clouduct-tf bootstrap
./clouduct-tf apply global build
```
### Prepare Repo
For now, you need to manually add the application repository. This will be automated through the clouduct-cli later on.
- Clone dummy-app repo: `git clone https://github.com/clouduct/dummyseedrepo`
- `cd dummyseedrepo`
- Add CodeCommit Repo as remote: `git remote add codecommit https://git-codecommit.eu-central-1.amazonaws.com/v1/repos/${applicationRepoName}`
- `git config credential.helper '!aws codecommit credential-helper $@'`
- `git config credential.UseHttpPath true`
- Now you're able to push your app to CodeCommit: `git push -u codecommit HEAD`


## Usage
```
./clouduct-tf bootstrap
./clouduct-tf apply global build
```

`plan` potentially only works with one phase, as other phases might need terraform outputs of another one.


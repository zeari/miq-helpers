# miq-helpers
```./precious.sh``` Sets up dockerized openshift locally according to this guide:
http://ghost-justablog.rhcloud.com/setting-up-a-dockerized-openshift-on-fedora-20/

```./wait_for_miq.sh``` Restarts evm with ```rake evm:kill evm:start``` and times it.
* Run from manageiq directory

```./murphy.sh``` Runs Rubocop and haml-lint on <b>changes made in the last commit</b>
* Run from manageiq directory
* rubocop.rb file originally by skanev https://gist.github.com/skanev

```./fill_er_up.sh``` Adds providers and refreshes them.

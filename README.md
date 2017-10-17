# Rainforest Livefyre Automation

## Prerequisites

You will need the following installed on your machine:

1. [Firefox](http://www.mozilla.org/en-US/firefox/new/)

## Setup

Install Command Line Tools:

In a terminal type the following command: 
```bash
xcode-select --install
```
You should see a pop up saying that “xcode-select” requires the command line developer tools. Click Install
You will have to accept the license agreement


Install Homebrew:

You can get the latest command to install Homebrew from their website at https://brew.sh/
Alternatively you should be able to run the following command from a terminal:
```bash
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
After installing run the command: 
```bash
brew doctor
```
This will test to make sure everything installed correctly


Install Git

To install Git if it is not already installed, run the following commands from a terminal:
```bash
brew update
brew install git
```
To verify installation run: 
```bash
git —version
```
You will need to sign up for an account on github


Clone the repository:

In a terminal run the following in the directory where you would like to clone the Rainforest Livefyre automation repository:
```bash
git clone https://github.com/burbon000/rainforest_livefyre_automation.git
cd rainforest_livefyre_automation
```


Install Ruby Version Manager(RVM) to manage your Ruby environments:

```bash
curl -L https://get.rvm.io | bash -s stable
```
To verify installation, run: 

```bash
rvm -v
```
You must use version 2.3.3 of Ruby. To install version 2.3.3 of Ruby, run the following:

```bash
rvm install 2.3.3
```

If you have multiple versions of Ruby installed, RVM will automatically detect the version of Ruby used by an application based on the Gemfile.

Finally you must install the dependencies:

```bash
gem install bundler
bundle install
brew install geckodriver
```

## Running the tests

You can then run the tests using the following command:

```bash
bundle exec rainforest_test test_case.rb
```



## Advance features

### Timeouts

By default, we have configured Capybara to timeout after 20 seconds. This can be a little long and annoying while developing. This value is configurable through an environment variable.

```bash
CAPYBARA_WAIT_TIME=1 bundle exec rainforest_test test_case.rb
```

## Help!

If you find a bug with this, please email [qe@rainforestqa.com](mailto:qu@rainforestqa.com)

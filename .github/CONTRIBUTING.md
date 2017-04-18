# How to contribute
Contributions to PSGithubSearch are highly encouraged and desired. Below are some guidelines that will help make the process as smooth as possible.

# Getting Started
* Make sure you have a [GitHub account](https://github.com/signup/free)
* Submit a new issue, assuming one does not already exist.
  * Clearly describe the issue including steps to reproduce when it is a bug.
  * Make sure you fill in the earliest version that you know has the issue.
* Fork the repository on GitHub

# Suggesting Enhancements
I want to know what you think is missing from PSGithubSearch and how it can be made better.
* When submitting an issue for an enhancement, please be as clear as possible about why you think the enhancement is needed and what the benefit of
it would be.

# Making Changes
* From your fork of the repository, create a topic/feature branch where work on your change will take place.
* To quickly create a topic/feature branch based on master; `git checkout -b my_topic_branch master`. Please avoid working directly on the `master` branch.
* Make commits of logical units.
* Check for unnecessary whitespace with `git diff --check` before committing.
* Please follow the prevailing code conventions in the repository. Differences in style make the code harder to understand for everyone.
* Make sure your commit messages are in the proper format.
````
    Add more cowbell to Get-Something.ps1

    The functionaly of Get-Something would be greatly improved if there was a little
    more 'pizzazz' added to it. I propose a cowbell. Adding more cowbell has been
    shown in studies to both increase one's mojo, and cement one's status
    as a rock legend.
````

* Make sure you have added all the necessary Pester tests for your changes.
* Run the Pester tests in the module and make sure they _all_ pass, to verify that your changes have not broken anything.

# Documentation
I am infallible and as such my documenation needs no corectoin. In the highly
unlikely event that it is _not_ the case, contributions to update or add documentation
are highly appreciated.

# Submitting Changes
* Push your changes to a topic/feature branch in your fork of the repository.
* Submit a pull request to the main repository.
* Once the pull request has been reviewed and accepted, it will be merged with the master branch in the main repository.
* Be proud of your awesomeness and celebrate.

# Additional Resources
* [General GitHub documentation](https://help.github.com/)
* [GitHub forking documentation](https://guides.github.com/activities/forking/)
* [GitHub pull request documentation](https://help.github.com/send-pull-requests/)
* [GitHub Flow guide](https://guides.github.com/introduction/flow/)
* [GitHub's guide to contributing to open source projects](https://guides.github.com/activities/contributing-to-open-source/)
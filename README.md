# Kagi Orion iOS Demo Project

Welcome to my coding exercise 👋

I used MobileSafari.app as a reference and tried to copy the visuals, the animations and transitions where possible.

## Requirements
I followed all strong requirements as described in the exercise description ([see below](#exercise-description)).

- Main browser screen has a toolbar with back/forward, "new tab" and "tab switcher" buttons.
- Address bar with a refresh button.
- Swipe animation to navigate between tabs without having to go to the tab switcher.
- Interactive "swipe up" transition to open the tab switcher.
- Tab switcher lets you add a tab, open a tab, delete a tab, and go back to the browser (close the tab switcher).
- Tab switcher shows a screenshot of the browser view, and the title of the page.

## Additions
To make the user experience smoother, I added the following functionalities

- Address bar collapses and expands when the user scrolls
- Address bar has a progress bar (like Safari).
- Address bar has a stop loading button when loading (like Safari).
- Browser toolbar has a Home button navigating to `kagi.com`.
- Address bar accepts URLs as well as search terms (searches English Wikipedia for demo purposes).
- Address bar shows a magnifying glass icon when searching.
- Address bar shows only the host (and hides the `www.` if necessary), or the search term(s) instead of a full URL.
- Nice app icon with a banner to differentiate from the regular Orion app.
- App-wide tint colour aligned with the Kagi yellow/orange.

## Non-functional additions

I followed an MVVM approach to organise some business logic. I also used the delegate patterns to handle presentation and simple communication between ViewControllers. The delegate pattern is verbose but simple to use and widely used by UIKit, so I sits well with a simple project like this one at this stage. Having ViewModels allowed me to quickly write a few unit tests to ensure I didn't break basic core functionality as I went along.

See video demo [here](demo.mov).

## Caveats & Improvements
With more time, if I had the intent to "release" this app, I would do the following (in no specific order of importance):

- Some business logic still find itself in the ViewControllers and they are becoming a bit too big to my liking. I'd re-architect the existing screens so they would be able to support (much) more features without them becoming bloated or too coupled.
- Do an accessibility review.
- Improve the address bar collapsing/expanding behavior and animations, make them interactive and play better with the toolbar.
- Improve the accuracy and timing of the zoom-in/zoom-out animations (tab switcher) and add an animated blur overlay.
- Integrate the tab switching lateral animation into the interactive animation, like in Safari. It would probably mean rewriting entirely the container and the animator.
- Keep the underlying web content of webview in memory, so the page isn't reloadded each time the tab is re-opened.
- Better blend the chrome of the browser view with the background colour of the current page.
- Add "pull to refresh" to the browser view.
- Add ability to delete a tab (in the tab switcher) by swiping left (like Safari).
- Add ability to search for tabs in the tab switcher (like Safari).
- Improve the empty state for the address bar.
- Add the ability to create a new tab simply by "pulling more" laterally after the last tab (like Safari).
- Add an empty state for a new tab, to give more options to the user.
- Better adapt the UI for iPad

---

## Exercise description

Hi and welcome to your iOS/iPadOS development test project.

At Orion we’re committed to making a mobile browser that everyone will love to use.

It is common practice for us to have to think our of the box, and offer features far beyond what legacy browsers offer on iOS/iPadOS.

##### General guidelines:

- Deliverable is a Github repository with the app code and a video recording of the app performing project requirements
- Deadline to submit your solution is two weeks

Good luck and feel free to ask any clarifying questions!

Create an iOS/iPadOS web browser app using standard components, targeting iOS/iPadOS 13.0 and using Swift + UIKit.

Name it Orion.

### Specification

#### Main Screen

The app should have a basic minimal browser UI: WKWebView and a bottom toolbar with following buttons:

- Back button -> goes back in history if available
- Forward button -> goes forward in history if available
- New tab Button -> Opens a new tab and selects it.
- Tabs button -> Opens tab switcher view.

#### Address bar

Above the toolbar there should be an address bar where you can enter the url to proceed to a website.
The address bar should have a Refresh button inside that reloads the web view.

#### Animations

1. Add swipe animation to change tabs, same as on Safari. Swiping left or right on the address bar should animate to another tab
2. Add swipe up to open the tab switcher. Similar to Safari when you swipe up it should seamlessly open the tab switcher.

> Nice to have - when you are on last tab swipe left opens a new tab and animates to it same as Safari

#### Tab Switcher Screen

It should be a collection view of opened tabs.
Nice to have it you are able to grab website's screenshot to display it.
Do not bother with displaying favicons, use title alone or a generic icons.
Available actions on this screen, the UI/action placement is up to you.

- Add new tab
- Close the view
- Select tab
- Close tab

---

This is a UI/UX oriented assignment. The requirements above are intentionally missing detailed requirements.
It is up to you to decide on certain UI/UX decisions.
You may want to implement some UI/UX changes which are not listed here such us proper landscape and size classes support.
Or you may rethink the address bar UX, we want to give you freedom to display your UI/UX sense as well as technical capabilities of implementing them.

The Safari examples are just for inspiration purposes, as long as the animation and user flows look pretty you can deviate from it as you wish.
Strictly following Safari UI is okay too.

The goal is to deliver a minimalistic web browser, with focus on strong UI/UX.

You can prepare a small writeup of things that you found tricky or interesting.
Or if you run out of time you can write what would you add if you had more time.

Good Luck!
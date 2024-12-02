# Kagi Orion iOS Demo Project

Hi and welcome to your iOS/iPadOS development test project.

At Orion we’re committed to making a mobile browser that everyone will love to use.

It is common practice for us to have to think our of the box, and offer features far beyond what legacy browsers offer on iOS/iPadOS.

#### General guidelines:

- Deliverable is a Github repository with the app code and a video recording of the app performing project requirements
- Deadline to submit your solution is two weeks

Good luck and feel free to ask any clarifying questions!

Create an iOS/iPadOS web browser app using standard components, targeting iOS/iPadOS 13.0 and using Swift + UIKit.

Name it Orion.

## Specification

### Main Screen

The app should have a basic minimal browser UI: WKWebView and a bottom toolbar with following buttons:

- Back button -> goes back in history if available
- Forward button -> goes forward in history if available
- New tab Button -> Opens a new tab and selects it.
- Tabs button -> Opens tab switcher view.

### Address bar

Above the toolbar there should be an address bar where you can enter the url to proceed to a website.
The address bar should have a Refresh button inside that reloads the web view.

### Animations

1. Add swipe animation to change tabs, same as on Safari. Swiping left or right on the address bar should animate to another tab
2. Add swipe up to open the tab switcher. Similar to Safari when you swipe up it should seamlessly open the tab switcher.

> Nice to have - when you are on last tab swipe left opens a new tab and animates to it same as Safari

### Tab Switcher Screen

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
# BookTDDSample

This project is to practice test-driven-development with iOS.</br>
Most of the project will be developed with TDD approach, but not all. </br>
Some asepects that can't be tested through XCTest will be done so by XCUIText </br>
ex) Colleciton view cell will display

Specifications are as follows.
- The app has two screen. One is search tab, and the other is bookmark tab.
- When user writes word and tap on the search button, it fetchs book with that word.
- Pagination should be enabled if user scrolls the list to the bottom.
- When user taps on the item, the app should navigate to detail screen.
- Detail screen should show all the detail available with the choosen book.
- When users taps on the bookmark, it should be bookmarked and shown on the bookmark tap.
- User can cancel bookmark.
- When user taps on the bookmarked item, it should navigate to detail screen.

# Uzzers
Uzzers is a simple user management tool written in Swift that demonstrates C and R verbs of a CRUD application. The app is using Realm as its underlying persistence method.
## Installation
Use XCode (version 10.1 or above) for building and running.
## Note on test cases
If you check XCTestCase tests records persisted by the app before might result in some tests failing. Be sure to delete the app each time before running XCTestCases.
## Contributing
It isn't intended for contribution, it's only for demonstration purposes.
## Potentional improvements or variant solutions
If it were a real project there are a few tasks that might be implemented as improvements:
- Form handling with Eureka
- Implementing a convenience init in DBService singleton to use in-memory database (for test cases no to mix their data into real app data)
## License
[MIT](https://choosealicense.com/licenses/mit/)

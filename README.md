# WineCellar

A Combine Publisher which provides your wine list from [CellarTracker.com
](http://www.cellartracker.com)

One possible use case would be a swift script like the following:

``` swift
import WineCellar
import Foundation
import Combine

let cellar = WineCellar()
let semaphore = DispatchSemaphore(value: 0)

let cancellable = cellar.$inventory.sink { bottlesResult in
    switch bottlesResult {
    case .pending:
        print("Fetching the list of wines")
    case .success(let bottles):
        print("fetched the csvs and parsed \(bottles)")
        semaphore.signal()
    case .failure(let error):
        semaphore.signal()
        print("failed to fetch the file \(error)")
    }
}

let _ = cellar.refreshCellar(uname: "roderic", password: "bananabananabanana")

_ = semaphore.wait(timeout: .now() + 5)
```

From the command line do this:

` $> swift run`

Should probably also make an app out of this.

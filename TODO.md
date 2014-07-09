# Neptune Coffee Todo

## .directories (dot-directories)

#### Goals
* Support putting test files inside the directory of the module they are testing.
* Reduce management and refactoring complexity: Just move the module's directory and all its tests move with it.
* Make it easy to load the test files of one module, and all its sub-modules.
* Make it so you don't have to load all test files globally.
* Make a general solution so many different types of cross-cutting, non-production support files can be co-located within their modules. For example, performance-testing is separate from correctness testing. 

#### Status Quo

* Currently requiring a module includes all js files in all sub-directories. This makes it impossible to co-locate test files in the same structure unless you want the test files deployed to production.
* Currently all tests are loaded at once, globally. This is getting awkward and slow. Mocha supports only running selected tests, but the current system sill loads all test and, consequently, all source-code. Combine that with live-reload and there is a lot of uneccessary work being done with every red-green test cycle.
* Currently directories that start with a dot don't work at all. It generates namespaces that start with a "." - illegal in javascript. 

#### Propsed Solution

* Place your test files in a subdirectory named ".test"
* Directories that start with a dot are treated specially:
  * They are not included by default when requiring a parent module-directory.
  * They must be explicitly required: require ".test"
  * They are linked into the NeptuneCoffee namespace structure as-if their directory-name didn't have a ".". Ex: ".test" becomes the Test namespace under its parent directory
* NOTE: You shouldn't have both "test" and ".test" subdirs under the same parent.
* To included all dot-directories of the same name anywhere under a parent-directory, require the parent-directory's path and name concatinated with the dot-directory's name. Ex:
	* Directory structure:
		* foo
		* foo/.test
		* foo/.perf
		* foo/bar
		* foo/bar/.test
		* foo/bar/.perf
	* require ["foo.test"], (Foo) -> 
		* imports all .test directories in foo and all its sub-directories
		* returns Foo, with (at-least) the following namespaces set:
			* Foo.Bar
			* Foo.Test
			* Foo.Bar.Test	
	* require ["foo.perf"], (Foo) -> 
		* imports all .perf directories in foo and all its sub-directories
		* returns Foo, with (at-least) the following namespaces set:
			* Foo.Bar
			* Foo.Perf
			* Foo.Bar.Perf
	* require ["foo", "foo.perf", "foo.test"], (Foo, FooPerf, FooTest) -> 
		* Foo == FooPerf == FooTest
		* returns Foo, with (at-least) the following namespaces set:
			* Foo.Bar
			* Foo.Perf
			* Foo.Bar.Perf
			* Foo.Test
			* Foo.Bar.Test	
		
## don't generate files for directories with no JavaScript files		
## Auto-delete generated files no longer needed
## should we support CSS concatination?
## including a namespace file and one JavaScript file in that namespace doesn't guarantee the JavaScript file's return value is attached to that namespace.

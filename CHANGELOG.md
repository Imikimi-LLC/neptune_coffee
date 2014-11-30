# Neptune Coffee Changelog

### v0.2.5

Added: rake reset_examples

Changed generated 'namespace.js' semantics. It no longer includes sub-
namespaces. Include the generated module file to get all sub-namespaces.

### v0.2.4

Updated Generator#generate_all to now return a Hash of Arrays (instead Hash of Hashes).

### v0.2.3

Generator#generate_all now returns a Hash of information on what was done:

* current_files: {}
* generated_files: {}
* skipped_files: {}

NOTE - Each {} is a Hash from Pathname objects to True.

### v0.2.2

* Added "// path:" comment to each generated file to make debugging easier. "What namespace.js file is this?"
* Stopped clobbering global properties: Added "var" before variable creation in namespace.js files.

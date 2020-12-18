# Eiffel PDF Library
This library is dependent on the wrap_cairo library. You will need to clone into this library, paying special attention to its installation instructions and the finish_freezing -library step, which makes the cairo library available to wrap_cairo and then to PDF (this library).

# Work in Progress
This library is a work in progress. Expect many changes over the coming weeks and months. Please ask for features as you might like, want, or need.

# Use
The library is designed to be simple. Open the "test" target of the ECF project and explore the testing classes, especially the {PDF_FACTORY_TEST_SET}.pdf_factory_page_tests method. This test feature showcases much of the work accomplished in just a few hours time (as of the "first_commit").

## Basic Steps
1. Create an instance of {PDF_FACTORY} with the appropriate "make" creation call.
2. Get a reference to {PDF_FACTORY}.page and apply "page-calls" to it.

Page calls will be actions like `apply_text` and `crlf` or `indent_one` and so on.

3. When you are ready for a new page, make a call to (saving the reference) {PDF_FACTORY}.next_page. Repeat step #2.
4. When you are ready to end your document, make a call to {PDF_FACTORY}.destroy, which will end-off your document and save it to the file name you used at the creation of the factory.

# NOTES
Presently, only a PDF file is created. There are facilities in Cairo for making PDF Streams for streaming a PDF document to a client-caller, but this functionality is not implemented yet in this library. Coming soon, I am quite sure!

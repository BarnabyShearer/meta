Render a HTML overlay over existing PDF files.

A wrapper for https://weasyprint.org/ which allows compositing with existing PDF files.

It parses the HTML looking for <img> tags with src urls ending ".pdf". Each one begins a new page and copies all source pages overlaying the weasyprint output.
The magic value "blank.pdf" outputs sections HTML without overlaying.

Usage
-----

.. code-block:: bash

    htmloverpdf < test.html > test.pdf


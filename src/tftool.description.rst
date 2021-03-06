Ergonomic utilities for the terraform CLI.

Usage
-----

.. code-block:: bash

    # Force terraform to be a bit more Unix philosophy
    alias tfplan="terraform plan -refresh=false -input=false -out=/tmp/plan > /dev/null && terraform show -json /tmp/plan"
    alias tfapply="xargs -or0 terraform apply"
    alias tfimport="xargs -or0L2 terraform import"

    # Only create new resources
    tfplan | tftool target --no-updates | tfapply

    # Automatically import new resources if their name/index matches the id.
    tfplan | tftool autoimport | tfimport

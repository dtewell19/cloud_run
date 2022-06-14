package main

import data.tags_validation

module_address[i] = address {
    changeset := input.resource_changes[i]
    address := changeset.address
}

tags_pascal_case[i] = resources {
    changeset := input.resource_changes[i]
    tags  := changeset.change.after.tags
    resources := [resource | resource := module_address[i]; val := tags[key]; not tags_validation.key_val_valid_pascal_case(key, val)]
}

tags_contain_minimum_set[i] = resources {
    changeset := input.resource_changes[i]
    tags := changeset.change.after.tags
    resources := [resource | resource := module_address[i]; not tags_validation.tags_contain_proper_keys(changeset.change.after.tags)]
}

deny[msg] {
    changeset := input.resource_changes[_]
    changeset.provider_name == "registry.terraform.io/hashicorp/aws"
    split(changeset.address, ".")[0] != "data"

    required_tags := {"apm_id", "dept", "environment"}
    provided_tags := {tag | changeset.change.after.tags_all[tag]}
    missing_tags := required_tags - provided_tags

    count(missing_tags) > 0

    msg := sprintf("%v is missing required tags: %v", [
        changeset.address,
        concat(", ", missing_tags),
    ])
}

deny[msg] {
    resources := tags_pascal_case[_]
    resources != []
    msg := sprintf("Invalid tags (not pascal case) for the following resources: %v", [resources])
}
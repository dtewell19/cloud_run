package tags_validation

minimum_tags = {"ApplicationRole", "Owner", "Project"}

key_val_valid_pascal_case(key, val) {
    is_pascal_case(key)
    is_pascal_case(val)
}

is_pascal_case(string) {
    re_match(`^([A-Z][a-z0-9]+)+`, string)
}

tags_contain_proper_keys(tags) {
    changeset := input.resource_changes[_]
    changeset.provider_name == "registry.terraform.io/hashicorp/google"
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
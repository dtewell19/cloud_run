package tags_validation

key_val_valid_pascal_case(key, val) {
    is_pascal_case(key)
    is_pascal_case(val)
}

is_pascal_case(string) {
    re_match(`^([A-Z][a-z0-9]+)+`, string)
}
"""Critical bug fix used in the Git Flow practice hotfix."""


def safe_divide(dividend, divisor):
    """Return a division result without crashing on zero division."""
    if divisor == 0:
        return "Division by zero is not allowed."
    return dividend / divisor

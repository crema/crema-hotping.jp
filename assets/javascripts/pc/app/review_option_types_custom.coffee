$(document).on "change", ".checkbox-review-option-search", (e) =>
  name = $(e.target).attr("name")
  value = $("input[name='" + name + "']:checked").map(-> return $(this).val()).get().join(",")

  $review_option_type = $("#" + name)
  if value == ""
    type_name = $review_option_type.data("type-name")
  else
    type_name = value
  $review_option_type.find(".type-name").html(type_name)

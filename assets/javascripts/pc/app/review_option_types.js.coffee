class ReviewOptionType
  constructor: ->
    $(document).on "click", ".link-review-option-type", (e) =>
      $review_option_type = $(e.target).closest(".review_option_type")
      $dropdown_menu = $review_option_type.find(".dropdown-menu")

      is_selected = $review_option_type.hasClass("selected")
      @close_dropdown_menu()

      if !is_selected
        $review_option_type.addClass("selected")
        $dropdown_menu.show()
        lib.animation.fade_in $dropdown_menu, complete: ->
          $dropdown_menu.find("input").focus()

        $(document).on "click", @on_click_screen

    $(document).on "change", ".checkbox-review-option-search", (e) =>
      name = $(e.target).attr("name")
      key = "option_" + name.replace("review_option_type_", "")
      value = $("input[name='" + name + "']:checked").map(-> return $(this).val()).get().join(",")

      $review_option_type = $("#" + name)
      if value == ""
        type_name = $review_option_type.data("type-name")
      else
        type_name = value
      $review_option_type.find(".type-name").html(type_name)

      @filter(key, value)

    $(document).on "keydown", ".input-review-option-search", (e) =>
      if e.keyCode is 13
        @search($(e.target))

    $(document).on "click", "ul.review_option_types .link-search", (e) =>
      @search($(e.target).parent().find("input"))

    @set_options_position()

  search: ($input) ->
    key = "option_" + $input.attr("name").replace("review_option_type_", "")
    value = $input.val()
    @filter(key, value)

  filter: (key, value) ->
    url_builder = new UrlBuilder(lib.history.get_current_url())
    url_builder.remove_param("page")
    url_builder.add_param("atarget", "reviews")
    url_builder.add_param("aloading", ".page")
    if value
      url_builder.add_param(key, value)
    else
      url_builder.remove_param(key)

    $.ajax {
      url: url_builder.build(),
      type: "get",
      dataType: "script"
    }

  close_dropdown_menu: ->
    $(document).off "click", @on_click_screen
    $(".review_option_type.selected").each (i, e) ->
      $review_option_type = $(e)
      $review_option_type.removeClass("selected")
      $dropdown_menu = $review_option_type.find(".dropdown-menu")
      lib.animation.fade_out $dropdown_menu, complete: ->
        $dropdown_menu.hide()

  set_options_position: ->
    $(".nonlast-option").each ->
      $this = $(this)
      $this.css "right", ($this.parent().width() - $this.width() + 6) * 0.5

  on_click_screen: (e) ->
    if $(e.target).closest("ul.review_option_types").length == 0
      app.review_option_type.close_dropdown_menu()


app.review_option_type = new ReviewOptionType


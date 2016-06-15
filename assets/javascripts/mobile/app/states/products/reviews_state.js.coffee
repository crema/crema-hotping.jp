class ProductsReviewsState
  on_enter: (old_state_name, args) ->
    $("#topbar li.sort-container").show()

    args.elements.find(".show-reviews-index").click ->
      app.window.redirect_to $(this).data("reviews-index-url")

    app.search_toggle.init(args.elements)
    app.search.init(args.elements.find(".menu, .review_options_search_container"))

  on_exit: (new_state_name, args) ->
    $("#topbar li.sort-container").hide()

app.products_reviews_state = new ProductsReviewsState

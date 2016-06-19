class Form
  enable_validate: ->
    $("form[data-validate]").enableClientSideValidations()

  select: ($select, args) ->
    applied_key = "select2-applied"
    return if $select.data(applied_key)
    $select.data(applied_key, true)

    select_args = {minimumResultsForSearch: -1}
    select_args = $.extend(select_args, args) if args

    $select.select2(select_args)
    if args && args.drop_down_html
      drop_down_html = args.drop_down_html
    else
      drop_down_html = "<i class='fa sort-down'></i>"
    $select.prev().find(".select2-arrow").after(drop_down_html)
    $select.on "select2-focus", (e) ->
      $("input[type='text'], textarea").blur()

app.form = new Form

$(document).on "history:updated", (e, element) ->
  app.form.enable_validate()

  $(element).find("select.select2").each (i, e) ->
    $e = $(e)
    select_args = {}
    if $e.data("width")
      select_args.width = $e.data("width")
      select_args.dropdownAutoWidth = true

    select_args.drop_down_html = $e.data("drop-down-html") if $e.data("drop-down-html")

    app.form.select($e, select_args)

$(document).on "history:loaded", ->
  $(".select2-container").remove()

$ ->
  $(document).on lib.ui_util.textchange_events, ".count-limit", (e) ->
    $input = $(this)
    $limit_counter = $input.closest(".limit-count-container").find(".limit-counter")
    val = $input.val()
    maxlength = parseInt($input.attr("maxlength"))
    # exclude space
    if $input.data("up-counter")
      count = val.replace(/\s/g, "").length
    else
      count = maxlength - val.replace(/\s/g, "").length

    if count >= 0
      $limit_counter.html(count)
    else
      if $.browser.msie
        $input.val(val.substr(0, maxlength))
      $limit_counter.html(0)

$(document).on "change", "select.select2", (e) ->
  $target = $(e.target)
  if $target.data("keep-blank-value")
    $option = $target.find("option[value='']")
    if $option
      $("#s2id_" + e.target.name + " .select2-chosen").html($option.text())

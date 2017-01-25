import $ from "jquery"

export default function() {
  $(function() {
    $(document).on('click', 'a[data-remote="true"]', function(event) {
      event.preventDefault();
      $.get($(this).attr('href'));
    });

    if (document.getElementById('steps')) {
      $('.action-select').on('change', function() {
        toggleVisibility(this);
      });

      $('.action-select').each(function(_, elm) {
        toggleVisibility(elm);
      });
    }
  });
};

const toggleVisibility = function(elm) {
  const form = $(elm).closest('form');
  const value = $(elm).val();
  const visible = $(form).find('[data-visible="VISIT_URL"]');
  const hidden = $(form).find('[data-hidden="VISIT_URL"]')

  if (value == 'VISIT_URL') {
    visible.show().find('input').attr('disabled', false);
    hidden.hide().find('input').attr('disabled', true);
  } else {
    visible.hide().find('input').attr('disabled', true);
    hidden.show().find('input').attr('disabled', false);
    if (value == 'CLICK') {
      $(form).find('[data-name="CLICK"]').hide().find('input').attr('disabled', true);
    }
  }
}

const toggleDisabled = function(elm, disabled) {
  $(elm).find('input').attr('disabled', disabled);
}

/*
 * $("#container").append("<%= escape_javascript(render("post.html", post: @post)) %>
 * render conn, "index.html", layout: {MyApp.LayoutView, "admin.html"}
 * render conn, "index.html", layout: false
 * conn = put_layout conn, false
 */


$(document).ready(function() {
  var currentPage = 1;
  var perPage = 12;
  var magTypeFilter = '';

  function loadFeatures(page) {
    $.ajax({
      url: '/api/v1/features',
      type: 'GET',
      data: { page: page, per_page: perPage, 'filters[mag_type]': magTypeFilter },
      dataType: 'json',
      success: function(response) {
        var features = response.data;
        var paginationInfo = response.pagination;

        var featuresList = $('#features-list');
        featuresList.empty();

        features.forEach(function(feature) {
    var listItem = $('<li class="feature-item"></li>');
    var attributes = feature.attributes;
    var coordinates = attributes.coordinates;

    listItem.html('<strong class="feature-id">' + feature.id + '</strong><br>' +
        '<div class="feature-title">' + attributes.title + '</div><br>' + // Título debajo del ID
        '<strong>External ID:</strong> ' + attributes.external_id + '<br>' +
        '<strong>Magnitude:</strong> ' + attributes.magnitude + '<br>' +
        '<strong>Place:</strong> ' + attributes.place + '<br>' +
        '<strong>Time:</strong> ' + attributes.time + '<br>' +
        '<strong>Tsunami:</strong> ' + attributes.tsunami + '<br>' +
        '<strong>Mag Type:</strong> ' + attributes.mag_type + '<br>' +
        '<strong>Longitude:</strong> ' + coordinates.longitude + '<br>' +
        '<strong>Latitude:</strong> ' + coordinates.latitude);

    var commentForm = $('<div class="comment-form"></div>');
    commentForm.html('<h2>Add Comment</h2>' +
        '<textarea class="comment-body" rows="4" cols="50"></textarea><br>' +
        '<button class="submit-comment">Submit Comment</button>' +
        '<div class="comment-message"></div>');

    listItem.append(commentForm);
    featuresList.append(listItem);
});

        var prevPageBtn = $('#prevPage');
        var nextPageBtn = $('#nextPage');

        if (currentPage > 1) {
          prevPageBtn.show();
        } else {
          prevPageBtn.hide();
        }

        if (currentPage < paginationInfo.total) {
          nextPageBtn.show();
        } else {
          nextPageBtn.hide();
        }        
      },
      error: function(xhr, status, error) {
        console.error('Error retrieving feature data:', error);
      }
    });
  }

  loadFeatures(currentPage);

  $('#prevPage').on('click', function() {
    if (currentPage > 1) {
      currentPage--;
      loadFeatures(currentPage);
    }
  });

  $('#nextPage').on('click', function() {
    currentPage++;
    loadFeatures(currentPage);
  });

  $('#magTypeFilter').on('change', function() {
    magTypeFilter = $(this).val();
    currentPage = 1;
    loadFeatures(currentPage);
  });

  $(document).on('click', '.submit-comment', function(e) {
    e.preventDefault();
    var submitBtn = $(this);
    var featureId = submitBtn.closest('.feature-item').find('.feature-id').text();
    var body = submitBtn.siblings('.comment-body').val();
    var csrfToken = $('meta[name="csrf-token"]').attr('content');
    var commentMessage = submitBtn.siblings('.comment-message');

    $.ajax({
      type: 'POST',
      url: '/api/v1/features/' + featureId + '/comments',
      data: { feature_id: featureId, body: body },
      headers: {
        'X-CSRF-Token': csrfToken
      },
      success: function(response) {
        var commentHtml = '<li>' + response.body + '</li>';
        submitBtn.siblings('.comments').append(commentHtml);
        commentMessage.text('Comment submitted successfully');
        submitBtn.siblings('.comment-body').val('');
      },
      error: function(xhr, status, error) {
        console.error(error);
        commentMessage.text('Error submitting comment');
      }
    });
  });
});
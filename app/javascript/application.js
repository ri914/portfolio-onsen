var working = false;

$('.login').on('submit', function(e) {
  e.preventDefault();
  if (working) return;

  working = true;
  var $this = $(this);
  var $state = $this.find('button > .state');

  $this.addClass('loading');
  $state.html('Authenticating');

  setTimeout(function() {
    $this.addClass('ok');
    $state.html('Welcome back!');

    setTimeout(function() {
      $state.html('Log in');
      $this.removeClass('ok loading');
      working = false;
    }, 4000);
  }, 3000);
});

$(document).ready(function() {
  $('.file-input').on('change', function() {
    var input = this;
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function(e) {
        $('.current-avatar-container img').attr('src', e.target.result);
      };
      reader.readAsDataURL(input.files[0]);
    }
  });
});

$(function() {
  setTimeout("$('.flash').fadeOut('slow')", 3000);
});

$(function() {
  setTimeout("$('.alert').fadeOut('slow')", 3000);
});

$(document).ready(function() {
  const $imageUpload = $('#image-upload');
  const $previewContainer = $('#image-preview');
  const $form = $('#onsen-form');
  const $waterQualityCheckboxes = $('input[name="onsen[water_quality_ids][]"]');
  const $existingPreview  = $('#edit-image-preview');
  
  let imageIndex = $('.img-container').length;
  const dataTransfer = new DataTransfer();

  $imageUpload.on('change', function(event) {
    const files = Array.from(event.target.files);

    files.forEach((file) => {
      const reader = new FileReader();
      reader.onload = function(e) {
        const $imgContainer = $('<div class="img-container new-image"></div>').attr('data-index', imageIndex);
        
        const $img = $('<img>', { src: e.target.result, class: 'img-preview' });
        $imgContainer.append($img);

        const $descriptionInput = $('<input>', {
          type: 'text',
          name: 'onsen[new_descriptions][]',
          placeholder: '画像の説明',
          class: 'form-control mt-2 description-input'
        });
        $imgContainer.append($descriptionInput);

        const $removeBtn = $('<button>', {
          html: '&times;',
          class: 'remove-btn',
          click: function() {
            $imgContainer.remove();
            updateFileList(file);
          }
        });
        $imgContainer.append($removeBtn);

        $previewContainer.append($imgContainer);
        dataTransfer.items.add(file);
        $imageUpload[0].files = dataTransfer.files;

        imageIndex++;
      };
      reader.readAsDataURL(file);
    });
  });

  function updateFileList(fileToRemove) {
    const updatedFiles = Array.from(dataTransfer.files).filter(file => file.name !== fileToRemove.name);
    dataTransfer.items.clear();
    updatedFiles.forEach(file => dataTransfer.items.add(file));
    $imageUpload[0].files = dataTransfer.files;
  }

  $form.on('submit', function(event) {
    const anyChecked = $waterQualityCheckboxes.is(':checked');
    if (!anyChecked) {
      event.preventDefault();
      alert('泉質を選択してください。');
      $waterQualityCheckboxes.first().focus();
    }
  });
});

$(document).ready(function() {
  const guestAlert = "ゲストユーザーはこの機能を利用できません。";

  function restrictForGuest(selector) {
    $(document).on('click', selector, function(event) {
      if ($(this).data('guest') === true || $(this).data('guest') === 'true') {
        alert(guestAlert);
        event.preventDefault();
      }
    });
  }

  restrictForGuest('.post-link');
  restrictForGuest('.btn-post-onsen');
  restrictForGuest('.bookmark-link');
  restrictForGuest('.edit-link');
  restrictForGuest('.edit-button');
  restrictForGuest('.user-dropdown-link');
  restrictForGuest('.save-button');

  $('form[action*="users"]').on('submit', function(event) {
    if ($(this).find('[data-guest="true"]').length > 0) {
      alert(guestAlert);
      event.preventDefault();
    }
  });
});

$(document).ready(function() {
  $('#sort-select').on('change', function() {
    const url = $(this).val();
    window.location.href = url;
  });
});

$(document).ready(function() {
  $('.save-button').on('click', function(event) {
    const isGuest = $(this).data('guest') === true || $(this).data('guest') === 'true';

    event.preventDefault();

    const onsenId = $(this).data('onsen-id');
    const form = $(`#bookmark-form-${onsenId}`);

    $.ajax({
      url: form.attr('action'),
      method: form.attr('method'),
      data: form.serialize(),
      headers: {
        'X-Requested-With': 'XMLHttpRequest'
      },
      success: function(data) {
        const button = $(`#bookmark-button-${onsenId}`);
        const countElement = $(`#count-${onsenId}`);

        if (data.saved) {
          button.addClass('saved');
          button.find('i').removeClass('fa-bookmark-o').addClass('fa-bookmark');
        } else {
          button.removeClass('saved');
          button.find('i').removeClass('fa-bookmark').addClass('fa-bookmark-o');
        }

        countElement.text(data.bookmarked_count);
      },
      error: function(xhr, status, error) {
        const response = xhr.responseJSON;
      
        if (response && response.error) {
          alert(response.error);
        } else {
          alert('ゲストユーザーはブックマーク機能を利用できません');
        }
      
        console.error('Error:', error);
      }   
    });
  });
});


$(document).ready(function() {
  $('.delete-onsen-btn').on('click', function(event) {
    if (!confirm('この温泉を削除しますか？')) {
      event.preventDefault();
    }
  });
});


$(document).ready(function() {
  $('.btn-primary, .search-button').on('click', function(event) {
    var keyword = $('.search-input').val().trim();

    if (keyword === '') {
      event.preventDefault();
      alert('キーワードを入力してください。');
    }
  });
});

$(document).ready(function() {
  const searchBtn = $('#search-btn');
  const guestLoginLink = $('#guest-login-link');

  if (searchBtn.length) {
    searchBtn.on('click', function(e) {
      const isGuest = searchBtn.data('guest') === false;
      const keyword = $('#search-keyword').val().trim();

      if (isGuest && keyword !== '') {
        e.preventDefault();
        const url = `/guest_login?keyword=${encodeURIComponent(keyword)}`;
        window.location.href = url;
      }
    });
  }
});

$(document).ready(function() {
  $('#detail-search-form').on('submit', function(e) {
    var keyword = $('#detail-search-form input[name="keyword"]').val().trim();
    var location = $('select[name="location"]').val(); 
    var waterQualityIds = $('input[name="water_quality_ids[]"]:checked').length;

    console.log("Keyword:", keyword);
    console.log("Location:", location);
    console.log("Water Quality IDs:", waterQualityIds);

    if (keyword === '' && (!location || location === '選択してください') && waterQualityIds === 0) {
      e.preventDefault();
      alert('キーワード、都道府県、または泉質のいずれかを入力してください。');
    }
  });
});

$(document).ready(function () {
  const replyInfo = $("#reply-info");
  const replyTarget = $("#reply-target");
  const parentMessageInput = $("#parent_message_id");
  const clearReplyButton = $("#clear-reply");

  $(".reply-link").on("click", function (event) {
    event.preventDefault();

    const messageId = $(this).data("message-id");
    const messageNumber = $(this).data("message-number");

    parentMessageInput.val(messageId);
    replyTarget.html(`>>#${messageNumber}`);
    replyInfo.show();

    const replyUrl = new URL(window.location);
    replyUrl.searchParams.set("parent_message_id", messageId);
    window.history.replaceState({}, "", replyUrl);
  });

  clearReplyButton.on("click", function () {
    parentMessageInput.val("");
    replyInfo.hide();

    const replyUrl = new URL(window.location);
    replyUrl.searchParams.delete("parent_message_id");
    window.history.replaceState({}, "", replyUrl);
  });

  function updateRemainingTimes() {
    $('.edit-time-remaining').each(function () {
      const editableUntil = parseInt($(this).data('editable-until'), 10);
      const now = Math.floor(Date.now() / 1000);
      const remainingSeconds = editableUntil - now;

      if (remainingSeconds > 0) {
        const minutes = Math.floor(remainingSeconds / 60);
        const seconds = remainingSeconds % 60;
        $(this).text(`(残り${minutes}分${seconds}秒)`);
      } else {
        $(this).text('(編集期限切れ)');
        const editButton = $(this).prev('.edit-button');
        if (editButton.length) {
          editButton.hide();
        }
      }
    });
  }

  updateRemainingTimes();
  setInterval(updateRemainingTimes, 1000);

  const $imageInput = $('#image-upload');
  const $previewContainer = $('.edit-room__current-image');

  $imageInput.on('change', function (event) {
    const files = event.target.files;
    if (files && files[0]) {
      const reader = new FileReader();

      reader.onload = function (e) {
        $previewContainer.html(`
          <img src="${e.target.result}" class="edit-room__uploaded-image" />
          <label class="edit-room__remove-image-label">
            <input type="checkbox" name="message[remove_image]" value="1" /> 画像を削除
          </label>
        `);
      };

      reader.readAsDataURL(files[0]);
    }
  });

  const previewContainer = $("#room-preview-container");
  const previewImage = $("#room-preview");
  const removeImageBtn = $("#remove-room-image");

  $imageInput.on("change", function (event) {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();

      reader.onload = function (e) {
        previewImage.attr("src", e.target.result);
        previewContainer.show();
      };

      reader.readAsDataURL(file);
    }
  });

  removeImageBtn.on("click", function () {
    $imageInput.val("");
    previewContainer.hide();
  });

  const modal = $("#image-modal");
  const modalImg = $("#modal-image");

  modal.hide();

  $(".message-image img").on("click", function () {
    let imageUrl = $(this).attr("src");
    modalImg.attr("src", imageUrl);
    modal.fadeIn();
  });

  $(".close-modal, #image-modal").on("click", function (event) {
    if (event.target === this) {
      modal.fadeOut();
    }
  });

  const lastMessage = $(".message-container").last();
  if (lastMessage.length) {
    const room = $(".room");
    const lastMessageBottom = lastMessage.offset().top + lastMessage.outerHeight();
    const roomScrollTop = room.scrollTop();
    const roomHeight = room.height();
  
    const scrollToPosition = lastMessageBottom - roomHeight;
  
    const finalScrollTop = Math.max(0, scrollToPosition);
  
    room.animate({ scrollTop: finalScrollTop }, 500);
  }

  $('.message-input').on('submit', function (e) {
    const content = $('.message-textarea').val().trim();
    const imageInput = $('#image-upload')[0];
    const hasImage = imageInput && imageInput.files.length > 0;

    if (!content && !hasImage) {
      alert('メッセージ内容または画像を入力してください');
      e.preventDefault();
    }
  });
});

$(document).ready(function() {
  $('.detail-image-container img').on('click', function() {
    var imgSrc = $(this).attr('src');
    $('#modal-image').attr('src', imgSrc);
    $('#image-modal').fadeIn();
  });

  $('.close-modal').on('click', function() {
    $('#image-modal').fadeOut();
  });

  $('#image-modal').on('click', function(e) {
    if ($(e.target).is('#image-modal')) {
      $(this).fadeOut();
    }
  });
});

$(document).ready(function() {
  $('.avatar-container img').on('click', function() {
    var imgSrc = $(this).attr('src');
    $('#modal-image').attr('src', imgSrc);
    $('#image-modal').fadeIn();
  });

  $('.close-modal').on('click', function() {
    $('#image-modal').fadeOut();
  });

  $('#image-modal').on('click', function(e) {
    if ($(e.target).is('#image-modal')) {
      $(this).fadeOut();
    }
  });
});

$(function () {
  $('[data-bs-toggle="tooltip"]').tooltip();
});

function setupRegionMenu() {
  const windowWidth = $(window).width();

  if (windowWidth <= 1023) {
    $(".region-toggle").off("click");
    $(".menu-item .region-link").off("click");

    $(".region-toggle").on("click", function () {
      $(".menu-list").toggleClass("open");
    });

    $(".menu-item .region-link").on("click", function (e) {
      const $this = $(this);
      const isTopLink = $this.data("direct") === true;

      if (isTopLink) return;

      e.preventDefault();
      const $item = $this.closest(".menu-item");
      $item.toggleClass("open");
    });
  } else {
    $(".menu-list").removeClass("open");
    $(".menu-item").removeClass("open");
    $(".region-toggle").off("click");
    $(".menu-item .region-link").off("click");
  }
}

$(document).ready(function () {
  setupRegionMenu();
  $(window).on("resize", setupRegionMenu);
});

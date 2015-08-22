module ApplicationHelper
  def bootstrap_alert_class_for_flash_type(type)
    type == 'notice' ? 'alert-info' : 'alert-danger'
  end

  def bootstrap_label_class_for_poll_status(status)
    { 'draft' => 'label-warning',
      'open' => 'label-success',
      'closed' => 'label-danger'
    }[status.to_s] || 'label-default'
  end
end

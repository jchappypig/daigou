class SegmentIoWrapper
  class << self
    def analytics
      @analytics ||= Segment::Analytics.new(
          write_key: Rails.configuration.try(:segment_io_key) || ENV['SEGMENT_IO_WRITE_KEY'],
          on_error: proc { |_status, msg| fail "SegmentIO Error: #{msg}" }
      )
    end

    def identify(user_id)
      analytics.identify(anonymous_id: SecureRandom.uuid, user_id: user_id)
    end

    def track_order
      analytics.track(anonymous_id: SecureRandom.uuid,
                      event: 'Create Order',
                      properties: {category: 'Orders'})
    end
  end
end

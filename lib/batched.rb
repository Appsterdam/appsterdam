module Batched
  DEFAULT_BATCH_SIZE = 512

  def _max_id
    connection.execute("SELECT MAX(id) FROM #{table_name}").first[0]
  end

  def _ids_in_batch(batch_size, index)
    (index*batch_size...(index+1)*batch_size).to_a
  end

  # Yields collections for the specified size until all records
  # have been returned in the most database efficient way. Note
  # that this doesn't guarantee a specific batch size.
  def batched(options={})
    max_batch_size = DEFAULT_BATCH_SIZE
    batch_count = (_max_id / max_batch_size.to_f).ceil
    (0...batch_count).each do |index|
      yield scoped(:conditions => { :id => _ids_in_batch(max_batch_size, index) }).all(options)
    end
  end
end

ActiveRecord::Base.send(:extend, Batched)
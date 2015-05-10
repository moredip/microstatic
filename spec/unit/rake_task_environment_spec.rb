require_relative '../../lib/microstatic/rake/task_environment'

module Microstatic module Rake

describe TaskEnvironment do
  let(:some_aws_access_key_id){ "SOME AWS ACCESS KEY ID" }
  let(:some_aws_secret_access_key){ "SOME AWS SECRET ACCESS KEY" }
  let(:valid_task_env) { TaskEnvironment.new(valid_opts,valid_env) }

  let(:valid_env) { {
    'AWS_ACCESS_KEY_ID' => some_aws_access_key_id,
    'AWS_SECRET_ACCESS_KEY' => some_aws_secret_access_key
  } }

  let(:valid_opts) { {
    bucket_name: 'some bucket name',
    source_dir: 'some source dir',
  } }

  def hash_except(hash,key_to_remove)
    hash.dup.tap{ |h| h.delete(key_to_remove) }
  end
  def valid_opts_except(key_to_remove)
    hash_except(valid_opts,key_to_remove)
  end
  def valid_env_except(key_to_remove)
    hash_except(valid_env,key_to_remove)
  end

  it 'exposes the bucket name' do
    expect( valid_task_env.bucket_name ).to eq('some bucket name')
  end

  it 'allows updating the bucket name' do
    valid_task_env.bucket_name = 'new bucket name'
    expect(valid_task_env.bucket_name).to eq('new bucket name')
  end

  it 'exposes the source dir' do
    expect( valid_task_env.source_dir ).to eq('some source dir')
  end

  describe 'check_for_mandatory_opts!' do
    it 'does nothing when everything is legit' do
      expect{ valid_task_env.check_for_mandatory_opts! }.to_not raise_error
    end

    it 'reports missing bucket_name' do
      task_env = TaskEnvironment.new( valid_opts_except(:bucket_name), valid_env )
      expect{ task_env.check_for_mandatory_opts! }.to raise_error('must provide a bucket_name')
    end

    it 'reports missing source_dir' do
      task_env = TaskEnvironment.new( valid_opts_except(:source_dir), valid_env )
      expect{ task_env.check_for_mandatory_opts! }.to raise_error('must provide a source_dir')
    end

    it 'does not check for aws creds in env' do
    end
  end

  describe 'check_for_aws_creds!' do
    it 'reports missing aws access key id' do
      task_env = TaskEnvironment.new( valid_opts,valid_env_except("AWS_ACCESS_KEY_ID") )
      expect{ task_env.check_for_aws_creds! }.to raise_error('must provide an aws access key id either via an :aws_access_key_id opt or an AWS_ACCESS_KEY_ID environment variable')
    end
    it 'reports missing aws secret access key' do
      task_env = TaskEnvironment.new( valid_opts,valid_env_except("AWS_SECRET_ACCESS_KEY") )
      expect{ task_env.check_for_aws_creds! }.to raise_error('must provide an aws secret access key either via an :aws_secret_access_key opt or an AWS_SECRET_ACCESS_KEY environment variable')
    end
  end

  it 'exposes aws creds from env' do
    expect( valid_task_env.aws_access_key_id ).to eq(some_aws_access_key_id)
    expect( valid_task_env.aws_secret_access_key ).to eq(some_aws_secret_access_key)
  end

  it 'exposes combined aws creds' do
    expect(valid_task_env.aws_creds).to eq({
      access_key_id: some_aws_access_key_id,
      secret_access_key: some_aws_secret_access_key
    })
  end

  describe 'when aws creds specified in opts' do
    let( :opts_with_access_key ) { valid_opts.merge( aws_access_key_id: 'overridden access key id', aws_secret_access_key: 'overridden secret access key' ) }
    let( :task_env ) { TaskEnvironment.new(opts_with_access_key,valid_env) }

    it 'exposes aws creds from opts, not to env' do
      expect(task_env.aws_access_key_id).to eq('overridden access key id')
      expect(task_env.aws_secret_access_key).to eq('overridden secret access key')
    end
  end

  describe '#task_name' do
    it 'exposes what was in opts' do
      task_env = TaskEnvironment.new(valid_opts.merge(name:'specified task name'),valid_env)
      expect(task_env.task_name_or('default name')).to eq('specified task name')
    end

    it 'uses default if nothing in opts' do
      expect( valid_task_env.task_name_or('default name') ).to eq('default name')
    end
  end
end

end end

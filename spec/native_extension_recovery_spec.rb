# frozen_string_literal: true

require 'spec_helper'
require 'tmpdir'
require 'fileutils'
require 'open3'

RSpec.describe 'Windows native extension recovery' do
  it 'preserves a nested extension target prefix from the generated Makefile' do
    Dir.mktmpdir do |root|
      bundle_path = File.join(root, 'vendor', 'bundle')
      gem_dir = File.join(bundle_path, 'ruby', '4.0.0', 'gems', 'json-3.0.2')
      extension_dir = File.join(gem_dir, 'ext', 'json', 'ext', 'generator')
      FileUtils.mkdir_p(extension_dir)
      File.write(File.join(extension_dir, 'Makefile'), "target_prefix = /json/ext\r\nTARGET = generator\r\n")
      File.write(File.join(extension_dir, 'generator.so'), 'native extension')

      script = File.expand_path('../scripts/recover-native-extensions.sh', __dir__)
      _stdout, stderr, status = Open3.capture3('bash', script, bundle_path)

      expect(status).to be_success, stderr
      expect(File).to exist(File.join(gem_dir, 'lib', 'json', 'ext', 'generator.so'))
      expect(File).not_to exist(File.join(gem_dir, 'lib', 'generator.so'))
      expect(File.read(File.join(gem_dir, 'lib', 'json', 'ext', 'generator.so'))).to eq('native extension')
    end
  end

  it 'finds the matching Makefile when Windows leaves the binary outside its build directory' do
    Dir.mktmpdir do |root|
      bundle_path = File.join(root, 'vendor', 'bundle')
      gem_dir = File.join(bundle_path, 'ruby', '4.0.0', 'gems', 'json-3.0.2')
      makefile_dir = File.join(gem_dir, 'ext', 'json', 'ext', 'generator')
      misplaced_binary_dir = File.join(gem_dir, 'ext')
      FileUtils.mkdir_p(makefile_dir)
      File.write(File.join(makefile_dir, 'Makefile'), "target_prefix = /json/ext\nTARGET = generator\n")
      File.write(File.join(misplaced_binary_dir, 'generator.so'), 'native extension')

      script = File.expand_path('../scripts/recover-native-extensions.sh', __dir__)
      stdout, stderr, status = Open3.capture3('bash', script, bundle_path)

      expect(status).to be_success, stderr
      recovered = File.join(gem_dir, 'lib', 'json', 'ext', 'generator.so')
      expect(File).to exist(recovered), "#{stdout}\n#{stderr}"
      expect(File.read(recovered)).to eq('native extension')
    end
  end

  it 'recovers a staged Windows binary when rv leaves no matching Makefile in the gem extension tree' do
    Dir.mktmpdir do |root|
      bundle_path = File.join(root, 'vendor', 'bundle')
      gem_dir = File.join(bundle_path, 'ruby', '4.0.0', 'gems', 'json-3.0.2')
      staged_binary = File.join(
        gem_dir,
        'ext',
        'json',
        'ext',
        'generator',
        'D:aappraisal2appraisal2vendorbundleruby',
        '4.0.0gems',
        'json-3.0.2.tmpabc123',
        'json',
        'ext',
        'generator.so'
      )
      FileUtils.mkdir_p(File.dirname(staged_binary))
      File.write(staged_binary, 'native extension')

      script = File.expand_path('../scripts/recover-native-extensions.sh', __dir__)
      stdout, stderr, status = Open3.capture3('bash', script, bundle_path)

      expect(status).to be_success, stderr
      recovered = File.join(gem_dir, 'lib', 'json', 'ext', 'generator.so')
      expect(File).to exist(recovered), "#{stdout}\n#{stderr}"
      expect(File.read(recovered)).to eq('native extension')
      mangled_dir = File.join(gem_dir, 'ext', 'json', 'ext', 'generator', 'D:aappraisal2appraisal2vendorbundleruby')
      expect(File).not_to exist(mangled_dir)
    end
  end

  it 'recovers a root-level extension when the Makefile has no target_prefix' do
    Dir.mktmpdir do |root|
      bundle_path = File.join(root, 'vendor', 'bundle')
      gem_dir = File.join(bundle_path, 'ruby', '4.0.0', 'gems', 'bigdecimal-4.1.3')
      extension_dir = File.join(gem_dir, 'ext', 'bigdecimal')
      FileUtils.mkdir_p(extension_dir)
      File.write(File.join(extension_dir, 'Makefile'), "TARGET = bigdecimal\n")
      File.write(File.join(extension_dir, 'bigdecimal.so'), 'native extension')

      script = File.expand_path('../scripts/recover-native-extensions.sh', __dir__)
      _stdout, stderr, status = Open3.capture3('bash', script, bundle_path)

      expect(status).to be_success, stderr
      recovered = File.join(gem_dir, 'lib', 'bigdecimal.so')
      expect(File).to exist(recovered)
      expect(File.read(recovered)).to eq('native extension')
    end
  end
end

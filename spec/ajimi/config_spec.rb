require 'spec_helper'

describe "Ajimi#Config" do

  describe ".load" do
    let(:ajimi_file_content) { <<-"AJIMIFILE"
source "source_host_value", {
  ssh_options: {
    host: "overriden_source_host_value",
    user: "source_user_value",
    key: "source_key_value"
  },
  enable_nice: true
}
target "target_host_value", {
  ssh_options: {
    user: "target_user_value",
    key: "target_key_value"
  },
  enable_nice: false
}
check_root_path "check_root_path_value"
pruned_paths [
  "/path_to_pruned1",
  "/path_to_pruned2"
]
ignored_paths [
  "/path_to_ignored1",
  "/path_to_ignored2"
]
ignored_contents ({
  "/path_to_content" => /ignored_pattern/
})
pending_paths [
  "/path_to_pending1",
  "/path_to_pending2"
]
pending_contents ({
  "/path_to_content" => /pending_pattern/
})
    AJIMIFILE
    }

    let(:loaded_config) { {
      source: (Ajimi::Server.new("source_host_value", {
          ssh_options: {
            host: "overriden_source_host_value",
            user: "source_user_value",
            key: "source_key_value"
          },
          enable_nice: true
        }
      )),
      target: (Ajimi::Server.new("target_host_value", {
          ssh_options: {
            user: "target_user_value",
            key: "target_key_value"
          },
          enable_nice: false
        }
      )),
      check_root_path: "check_root_path_value",
      pruned_paths: ["/path_to_pruned1", "/path_to_pruned2"],
      ignored_paths: ["/path_to_ignored1", "/path_to_ignored2"],
      ignored_contents: { "/path_to_content" => /ignored_pattern/ },
      pending_paths: ["/path_to_pending1", "/path_to_pending2"],
      pending_contents: { "/path_to_content" => /pending_pattern/ }
    } }

    before do
      expect(::File).to receive(:read).and_return(ajimi_file_content)
      @config = Ajimi::Config.load("./Ajimifile")
    end

    it "returns config hash" do
      expect(@config).to eq loaded_config
    end
    
  end
end

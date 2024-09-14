{
  config,
  hostname,
  nodeJob,
}:

{
  integrations = {
    prometheus_remote_write = [
      {
        url = "\${METRICS_REMOTE_WRITE_URL}";
        basic_auth = {
          username = "\${METRICS_REMOTE_WRITE_USERNAME}";
          password = "\${METRICS_REMOTE_WRITE_PASSWORD}";
        };
      }
    ];
    agent = {
      enabled = true;
      relabel_configs = [
        {
          action = "replace";
          source_labels = [ "agent_hostname" ];
          target_label = "instance";
        }
        {
          action = "replace";
          target_label = "job";
          replacement = "integrations/agent-check";
        }
      ];
      metric_relabel_configs = [
        {
          action = "keep";
          regex = "(prometheus_target_.*|prometheus_sd_discovered_targets|agent_build.*|agent_wal_samples_appended_total|process_start_time_seconds)";
          source_labels = [ "__name__" ];
        }
      ];
    };
    node_exporter = {
      enabled = true;
      disable_collectors = [
        "ipvs"
        "btrfs"
        "infiniband"
        "xfs"
        "zfs"
      ];
      netclass_ignored_devices = "^(veth.*|cali.*|[a-f0-9]{15})$";
      netdev_device_exclude = "^(veth.*|cali.*|[a-f0-9]{15})$";
      filesystem_fs_types_exclude = "^(autofs|binfmt_misc|bpf|cgroup2?|configfs|debugfs|devpts|devtmpfs|tmpfs|fusectl|hugetlbfs|iso9660|mqueue|nsfs|overlay|proc|procfs|pstore|rpc_pipefs|securityfs|selinuxfs|squashfs|sysfs|tracefs)$";
      relabel_configs = [
        {
          replacement = hostname;
          target_label = "instance";
        }
      ];
      metric_relabel_configs = [
        {
          action = "drop";
          regex = "node_scrape_collector_.+";
          source_labels = [ "__name__" ];
        }
        {
          action = "keep";
          regex = "node_arp_entries|node_boot_time_seconds|node_context_switches_total|node_cpu_seconds_total|node_disk_io_time_seconds_total|node_disk_io_time_weighted_seconds_total|node_disk_read_bytes_total|node_disk_read_time_seconds_total|node_disk_reads_completed_total|node_disk_write_time_seconds_total|node_disk_writes_completed_total|node_disk_written_bytes_total|node_filefd_allocated|node_filefd_maximum|node_filesystem_avail_bytes|node_filesystem_device_error|node_filesystem_files|node_filesystem_files_free|node_filesystem_readonly|node_filesystem_size_bytes|node_intr_total|node_load1|node_load15|node_load5|node_md_disks|node_md_disks_required|node_memory_Active_anon_bytes|node_memory_Active_bytes|node_memory_Active_file_bytes|node_memory_AnonHugePages_bytes|node_memory_AnonPages_bytes|node_memory_Bounce_bytes|node_memory_Buffers_bytes|node_memory_Cached_bytes|node_memory_CommitLimit_bytes|node_memory_Committed_AS_bytes|node_memory_DirectMap1G_bytes|node_memory_DirectMap2M_bytes|node_memory_DirectMap4k_bytes|node_memory_Dirty_bytes|node_memory_HugePages_Free|node_memory_HugePages_Rsvd|node_memory_HugePages_Surp|node_memory_HugePages_Total|node_memory_Hugepagesize_bytes|node_memory_Inactive_anon_bytes|node_memory_Inactive_bytes|node_memory_Inactive_file_bytes|node_memory_Mapped_bytes|node_memory_MemAvailable_bytes|node_memory_MemFree_bytes|node_memory_MemTotal_bytes|node_memory_SReclaimable_bytes|node_memory_SUnreclaim_bytes|node_memory_ShmemHugePages_bytes|node_memory_ShmemPmdMapped_bytes|node_memory_Shmem_bytes|node_memory_Slab_bytes|node_memory_SwapTotal_bytes|node_memory_VmallocChunk_bytes|node_memory_VmallocTotal_bytes|node_memory_VmallocUsed_bytes|node_memory_WritebackTmp_bytes|node_memory_Writeback_bytes|node_netstat_Icmp6_InErrors|node_netstat_Icmp6_InMsgs|node_netstat_Icmp6_OutMsgs|node_netstat_Icmp_InErrors|node_netstat_Icmp_InMsgs|node_netstat_Icmp_OutMsgs|node_netstat_IpExt_InOctets|node_netstat_IpExt_OutOctets|node_netstat_TcpExt_ListenDrops|node_netstat_TcpExt_ListenOverflows|node_netstat_TcpExt_TCPSynRetrans|node_netstat_Tcp_InErrs|node_netstat_Tcp_InSegs|node_netstat_Tcp_OutRsts|node_netstat_Tcp_OutSegs|node_netstat_Tcp_RetransSegs|node_netstat_Udp6_InDatagrams|node_netstat_Udp6_InErrors|node_netstat_Udp6_NoPorts|node_netstat_Udp6_OutDatagrams|node_netstat_Udp6_RcvbufErrors|node_netstat_Udp6_SndbufErrors|node_netstat_UdpLite_InErrors|node_netstat_Udp_InDatagrams|node_netstat_Udp_InErrors|node_netstat_Udp_NoPorts|node_netstat_Udp_OutDatagrams|node_netstat_Udp_RcvbufErrors|node_netstat_Udp_SndbufErrors|node_network_carrier|node_network_info|node_network_mtu_bytes|node_network_receive_bytes_total|node_network_receive_compressed_total|node_network_receive_drop_total|node_network_receive_errs_total|node_network_receive_fifo_total|node_network_receive_multicast_total|node_network_receive_packets_total|node_network_speed_bytes|node_network_transmit_bytes_total|node_network_transmit_compressed_total|node_network_transmit_drop_total|node_network_transmit_errs_total|node_network_transmit_fifo_total|node_network_transmit_multicast_total|node_network_transmit_packets_total|node_network_transmit_queue_length|node_network_up|node_nf_conntrack_entries|node_nf_conntrack_entries_limit|node_os_info|node_sockstat_FRAG6_inuse|node_sockstat_FRAG_inuse|node_sockstat_RAW6_inuse|node_sockstat_RAW_inuse|node_sockstat_TCP6_inuse|node_sockstat_TCP_alloc|node_sockstat_TCP_inuse|node_sockstat_TCP_mem|node_sockstat_TCP_mem_bytes|node_sockstat_TCP_orphan|node_sockstat_TCP_tw|node_sockstat_UDP6_inuse|node_sockstat_UDPLITE6_inuse|node_sockstat_UDPLITE_inuse|node_sockstat_UDP_inuse|node_sockstat_UDP_mem|node_sockstat_UDP_mem_bytes|node_sockstat_sockets_used|node_softnet_dropped_total|node_softnet_processed_total|node_softnet_times_squeezed_total|node_systemd_unit_state|node_textfile_scrape_error|node_time_zone_offset_seconds|node_timex_estimated_error_seconds|node_timex_maxerror_seconds|node_timex_offset_seconds|node_timex_sync_status|node_uname_info|node_vmstat_oom_kill|node_vmstat_pgfault|node_vmstat_pgmajfault|node_vmstat_pgpgin|node_vmstat_pgpgout|node_vmstat_pswpin|node_vmstat_pswpout|process_max_fds|process_open_fds";
          source_labels = [ "__name__" ];
        }
      ];
    };
  };
  logs = {
    configs = [
      {
        name = "integrations";
        clients = [
          {
            url = "\${LOGS_REMOTE_WRITE_URL}";
            basic_auth = {
              username = "\${LOGS_REMOTE_WRITE_USERNAME}";
              password = "\${LOGS_REMOTE_WRITE_PASSWORD}";
            };
          }
        ];
        positions = {
          filename = "/tmp/positions.yaml";
        };
        scrape_configs = [
          {
            job_name = "integrations/node_exporter_journal_scrape";
            journal = {
              max_age = "24h";
              labels = {
                instance = hostname;
                job = "integrations/node_exporter";
              };
            };
            relabel_configs = [
              {
                source_labels = [ "__journal__systemd_unit" ];
                target_label = "unit";
              }
              {
                source_labels = [ "__journal__boot_id" ];
                target_label = "boot_id";
              }
              {
                source_labels = [ "__journal__transport" ];
                target_label = "transport";
              }
              {
                source_labels = [ "__journal_priority_keyword" ];
                target_label = "level";
              }
            ];
          }
          {
            job_name = "integrations/node_exporter_direct_scrape";
            static_configs = [
              {
                targets = [ "localhost" ];
                labels = {
                  instance = hostname;
                  __path__ = "/var/log/{syslog,messages,*.log}";
                  job = "integrations/node_exporter";
                };
              }
            ];
          }
        ];
      }
    ];
  };
  metrics = {
    global = {
      scrape_interval = "15s";
    };
    wal_directory = "/tmp/grafana-agent-wal";
    configs = [
      {
        name = "integrations";
        remote_write = [
          {
            url = "\${METRICS_REMOTE_WRITE_URL}";
            basic_auth = {
              username = "\${METRICS_REMOTE_WRITE_USERNAME}";
              password = "\${METRICS_REMOTE_WRITE_PASSWORD}";
            };
          }
        ];
        scrape_configs = [
          {
            job_name = nodeJob;
            static_configs =
              let
                prometheus = config.services.babylon-node.config.api.prometheus;
              in
              [ { targets = [ "${prometheus.bind_address}:${toString prometheus.port}" ]; } ];
            metrics_path = "/prometheus/metrics";
          }
        ];
      }
    ];
  };
}

def DEPLOY_SERVICE = [
  'Clear':[],
  'Database': [
    ['service_name': 'Zookeeper'],
    ['service_name': 'Broker'],
    ['service_name': 'MySQL'],
    ['service_name': 'MongoDB'],
    ['service_name': 'ClickHouse']
  ],
  'Monitoring': [
    ['service_name': 'Zabbix'],
    ['service_name': 'Prometheus']
  ]
]

def REGION = [
  'Clear':[],
  'us': [
    ['server_name': 'us-kafka1-1.spnode.net'],
    ['server_name': 'us-kafka1-2.spnode.net'],
    ['server_name': 'us-kafka1-3.spnode.net']
  ],
  'eu': [
    ['server_name': 'eu-kafka1-1.spnode.net'],
    ['server_name': 'eu-kafka1-2.spnode.net']
  ]
]

def CREATED_SERVICES = [
  'Clear':[],
  'Zookeeper': [
    ['host_service':'us-zookeeper1-1.spnode.net'],
    ['host_service':'us-zookeeper1-2.spnode.net'],
    ['host_service':'us-zookeeper1-3.spnode.net']
  ],
  'Broker': [
    ['host_service':'us-kafka1-1.spnode.net'],
    ['host_service':'us-kafka1-2.spnode.net'],
    ['host_service':'us-kafka1-3.spnode.net']
  ],
  'MySQL': [
    ['host_service':'us-kafka1-1.spnode.net'],
    ['host_service':'us-kafka1-2.spnode.net'],
    ['host_service':'us-kafka1-3.spnode.net']
  ],
  'MongoDB': [
    ['host_service':'us-kafka1-1.spnode.net'],
    ['host_service':'us-kafka1-2.spnode.net'],
    ['host_service':'us-kafka1-3.spnode.net']
  ],
  'ClickHouse': [
    ['host_service':'us-kafka1-1.spnode.net'],
    ['host_service':'us-kafka1-2.spnode.net'],
    ['host_service':'us-kafka1-3.spnode.net']
  ]
]

properties([
    parameters([
        [$class: 'ChoiceParameter',
            choiceType: 'PT_SINGLE_SELECT',
            description: 'Select a Service',
            name: 'Serices',
            script: [
              $class: 'GroovyScript',
              fallbackScript: [ classpath: [], sandbox: false, script: 'return ["ERROR"]' ],
                script: [
                  classpath: [],
                  sandbox: true,
                  script:
                  """
                    def serices = ${DEPLOY_SERVICE.inspect()}
                    return serices.keySet() as List
                  """
                ]
            ]
        ],
        [$class: 'CascadeChoiceParameter',
            choiceType: 'PT_RADIO',
            name: 'Application',
            referencedParameters: 'Serices',
            script: [$class: 'GroovyScript',
                fallbackScript: [
                    classpath: [],
                    sandbox: true,
                    script: 'return ["ERROR"]'
                ],
                script: [
                    classpath: [],
                    sandbox: true,
                    script: """
                        switch(Serices) {
                          case ~/.*/:
                            def service = ${DEPLOY_SERVICE.inspect()}
                            def c_service = ${CREATED_SERVICES.inspect()}
                            return  service[Serices].service_name
                            return c_service.keySet() as List
                            break;
                          default:
                            return["ERROR"]
                        }
                    """.stripIndent()
                ]
            ]
        ],

        [$class: 'CascadeChoiceParameter',
            choiceType: 'PT_CHECKBOX',
            name: 'Dependencies',
            referencedParameters: 'Application',
            script: [$class: 'GroovyScript',
                fallbackScript: [
                    classpath: [],
                    sandbox: true,
                    script: 'return " " '
                ],
                script: [
                    classpath: [],
                    sandbox: true,
                    script: """
                        switch(Application) {
                          case ~/.*/:
                            def c_service = ${CREATED_SERVICES.inspect()}
                            if (Application == 'Broker') {
                              return c_service['Zookeeper'].host_service
                            }
                            if (Application == 'ClickHouse') {
                              return c_service['Zookeeper'].host_service
                            }
                            break;
                        }
                    """.stripIndent()
                ]
            ]
        ],
//VALUE FOR BROKER DOCKER TEMPLATE
        [$class: 'DynamicReferenceParameter',
            choiceType: 'ET_FORMATTED_HTML',
            name: 'BROKER_parameters',
            description: 'Dependencies kafka-broker',
            referencedParameters: 'Application',
            script: [$class: 'GroovyScript',
                fallbackScript: [
                    classpath: [],
                    sandbox: true,
                    script: 'return " " '
                ],
                script: [
                    classpath: [],
                    sandbox: true,
                    script: """
                      if (Application == 'Broker') {
                      return inputBox = '''
                      <table id="broker">
                        <tr><td>container_name</td><td>=</td><td><input name='value' type='text' class=' ' placeholder="kafka1-1"></td></tr>
                        <tr><td>kafka_dns_name</td><td>=</td><td><input name='value' type='text' class=' ' placeholder="kafka1-1.spnode.net"></td></tr>
                        <tr><td><h5>IP SECTION IN DOCKER TEMPLATE</td><td>
                        <tr><td>port_internal</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="9092"></td></tr>
                        <tr><td>ip_internal</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="172.17.0.1"></td></tr>
                        <tr><td>port_external</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="9092"></td></tr>
                        <tr><td>ip_external</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="172.17.0.1"></td></tr>
                        <tr><td>port_monitoring</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="9201"></td></tr>
                        <tr><td>ip_monitoring</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="172.17.0.1"></td></tr>
                        <tr><td><h5>BROKER SECTION IN DOCKER TEMPLATE</td><td>
                        <tr><td>broker_id</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="1"></td></tr>
                        <tr><td>kafka_heap_opts</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="10"></td></tr>
                        <tr><td><h5>CONNECT CONFIG SECTION IN DOCKER TEMPLATE</td><td>
                        <tr><td>kafka_zookeeper_connect</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="172.17.0.1:2281"></td></tr>
                        <tr><td>kafka_zookeeper_ssl_keystore_location</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="/etc/kafka/secrets/kafka1-1.net-keystore.p12"></td></tr>
                        <tr><td>kafka_zookeeper_ssl_keystore_password</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="strong"></td></tr>
                        <tr><td>kafka_zookeeper_ssl_key_password</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="strong"></td></tr>
                        <tr><td>kafka_zookeeper_ssl_truststore_location</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="/etc/kafka/secrets/truststore.p12"></td></tr>
                        <tr><td>kafka_zookeeper_ssl_truststore_password</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="strong"></td></tr>
                        <tr><td><h5>CONFIG PARAMETERS SECTION IN DOCKER TEMPLATE</td><td>
                        <tr><td>kafka_replica_fetch_max_bytes</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="20000000"></td></tr>
                        <tr><td>kafka_message_max_bytes</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="20000000"></td></tr>
                        <tr><td>kafka_log_retention_hours</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="168"></td></tr>
                        <tr><td>kafka_controller_socket_timeout_ms</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="60000"></td></tr>
                        <tr><td>kafka_connection_setup_teimeout_max_ms</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="40000"></td></tr>
                        <tr><td>kafka_request_timeout_ms</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="60000"></td></tr>
                        <tr><td><h5>SSL CONFIGS SECTION IN DOCKER TEMPLATE</td><td>
                        <tr><td>kafka_ssl_keystore_filename</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="kafka1-1.net-keystore.jks"></td></tr>
                        <tr><td>kafka_ssl_pass_file</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="ssl.creds"></td></tr>
                        <tr><td>kafka_ssl_truststore_filename</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="truststore.jks"></td></tr>
                        <tr><td>kafka_ssl_secrets_dir</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="/etc/kafka/secrets/"></td></tr>
                        <tr><td><h5>CLUSTER CONFIGS SECTION IN DOCKER TEMPLATE</td><td>
                        <tr><td>kafka_auto_leader_rebalance_enable</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="true"></td></tr>
                        <tr><td>kafka_default_replication_factor</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="1"></td></tr>
                        <tr><td>kafka_offsets_topic_replication_factor</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="1"></td></tr>
                        <tr><td>kafka_min_insync_replicas</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="1></td></tr>
                        <tr><td>kafka_transaction_state_log_min_isr</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="1></td></tr>
                        <tr><td>kafka_transaction_state_log_replication_factor</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="1></td></tr>
                        <tr><td><h5>VARS FOR adminclient-configs.conf</td><td>
                        <tr><td>sasl_username</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="connect"></td></tr>
                        <tr><td>sasl_password</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="connect-secret"></td></tr>
                        <tr><td>ssl_keystore_location</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="/etc/kafka/secrets/kafka1-1.net-keystore.jks"></td></tr>
                        <tr><td>ssl_keystore_password</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="strong"></td></tr>
                        <tr><td>ssl_truststore_location</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="/etc/kafka/secrets/truststore.jks"></td></tr>
                        <tr><td>ssl_truststore_password</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="strong"></td></tr>
                        <tr><td><h5>VARS FOR kafka_server_jaas.conf</td><td>
                        <tr><td>jaas_server_user_kafkabroker</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="user_kafkabroker"></td></tr>
                        <tr><td>jaas_server_password_kafkabroker_secret</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="kafkabroker-secret"></td></tr>
                        <tr><td>jaas_server_user_kafka_broker_metric_reporter</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="user_kafka-broker-metric-reporter"></td></tr>
                        <tr><td>jaas_server_password_kafkabroker_metric_reporter_secret</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="kafkabroker-metric-reporter-secret"></td></tr>
                        <tr><td>jaas_server_user_client</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="user_client"></td></tr>
                        <tr><td>jaas_server_password_client_secret</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="client_secret"></td></tr>
                        <tr><td>jaas_server_user_connect</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="user_connect"></td></tr>
                        <tr><td>jaas_server_password_connect_secret</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="connect_secret"></td></tr>
                        <tr><td>jaas_server_user_debezium</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="user_debezium"></td></tr>
                        <tr><td>jaas_server_password_debezium_secret</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="debezium_secret"></td></tr>
                        <tr><td>jaas_client_username</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="kafka"></td></tr>
                        <tr><td>jaas_client_password</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="kafka_secret"></td></tr>
                      </table>
                      '''
                      }
                    """.stripIndent()
                ]
            ],
            omitValueField: true
        ],


        [$class: 'CascadeChoiceParameter',
            choiceType: 'PT_SINGLE_SELECT',
            description: 'Select a region',
            name: 'Region',
            script: [$class: 'GroovyScript',
                fallbackScript: [
                    classpath: [],
                    sandbox: true,
                    script: 'return ["ERROR"]'
                ],
                script: [
                    classpath: [],
                    sandbox: true,
                    script: """
                      def region = ${REGION.inspect()}
                      return region.keySet() as List
                    """.stripIndent()
                ]
            ]
        ],

        [$class: 'CascadeChoiceParameter',
            choiceType: 'PT_CHECKBOX',
            name: 'Server',
            referencedParameters: 'Region',
            script: [$class: 'GroovyScript',
                fallbackScript: [
                    classpath: [],
                    sandbox: true,
                    script: 'return ["ERROR"]'
                ],
                script: [
                    classpath: [],
                    sandbox: true,
                    script: """
                        switch(Region) {
                          case ~/.*/:
                            def server = ${REGION.inspect()}
                            return  server[Region].server_name
                            break;
                          default:
                            return["ERROR"]
                        }
                    """.stripIndent()
                ]
            ]
        ]
    ])
])

pipeline {
    agent any
    parameters {
        string(name: 'old', defaultValue: ' ', description: 'OLD')
    }
    stages {
      stage('Deploy') {
          steps {
            script  {

                def mylistvalue = []
                def server_parameters = "${Server}".split(",")
                def zookeeper_parameters = "${params.Dependencies}".split(",")
                def broker_parameters = "${params.BROKER_parameters}".split(",")

                println "${params.old}"
                println "${server_parameters}"
                println "${zookeeper_parameters}"
                println "${broker_parameters}"

                for (i in broker_parameters ) {
                  mylistvalue.add(i)
                }

//                mylistkey.each{ println it }
//                mylistvalue.each{ println it }
            }
          }
        }

      stage('Load Kafka_pipeline') {
          steps {
            script {
                echo 'Run Load Kafka_pipeline'
                build job: 'Database/Broker', parameters: [
                string(name: 'DEPENDENCIES', value: "${Dependencies}"),
                string(name: 'SERVERS', value: "${Server}"),
                string(name: 'BROKER_PARAMETERS', value: "${BROKER_parameters}")
                ]
          }
        }
      }

      }
  }

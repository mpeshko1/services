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
                      <button click="alert('hi')">clk<\button>
                      if (Application == 'Broker') {
                      return inputBox = '''
                      <table id="broker">
                        <tr><td>container_name</td><td>=</td><td><input name='container_name' type='text' class=' '></td></tr>
                        <tr><td>kafka_dns_name</td><td>=</td><td><input name='kafka_dns_name' type='text' class=' '></td></tr>
                        <tr><td><h5>IP SECTION IN DOCKER TEMPLATE</td><td>
                        <tr><td>ip_internal</td><td>=</td><td><input name='value' type='list' class=' '></td></tr>
                        <tr><td>ip_external</td><td>=</td><td><input name='value' type='list' class=' '></td></tr>
                        <tr><td>ip_monitoring</td><td>=</td><td><input name='value' type='list' class=' '></td></tr>
                        <tr><td><h5>BROKER SECTION IN DOCKER TEMPLATE</td><td>
                        <tr><td>broker_id</td><td>=</td><td><input name='value' type='list' class=' '></td></tr>
                        <tr><td>kafka_heap_opts</td><td>=</td><td><input name='value' type='list' class=' '></td></tr>
                        <tr><td><h5>CONNECT CONFIG SECTION IN DOCKER TEMPLATE</td><td>
                        <tr><td>kafka_zookeeper_connect</td><td>=</td><td><input name='value' type='list' class=' '></td></tr>
                        <tr><td>kafka_zookeeper_ssl_keystore_location</td><td>=</td><td><input name='value' type='list' class=' '></td></tr>
                        <tr><td>kafka_zookeeper_ssl_keystore_password</td><td>=</td><td><input name='value' type='list' class=' '></td></tr>
                        <tr><td>kafka_zookeeper_ssl_key_password</td><td>=</td><td><input name='value' type='list' class=' '></td></tr>
                        <tr><td>kafka_zookeeper_ssl_truststore_location</td><td>=</td><td><input name='value' type='list' class=' '></td></tr>
                        <tr><td>kafka_zookeeper_ssl_truststore_password</td><td>=</td><td><input name='value' type='list' class=' '></td></tr>
                        <tr><td><h5>CONFIG PARAMETERS SECTION IN DOCKER TEMPLATE</td><td>
                        <tr><td>kafka_replica_fetch_max_bytes</td><td>=</td><td><input name='value' type='list' class=' '></td></tr>
                        <tr><td>kafka_message_max_bytes</td><td>=</td><td><input name='value' type='list' class=' '></td></tr>
                        <tr><td>kafka_log_retention_hours</td><td>=</td><td><input name='value' type='list' class=' '></td></tr>
                        <tr><td>kafka_controller_socket_timeout_ms</td><td>=</td><td><input name='value' type='list' class=' '></td></tr>
                        <tr><td>kafka_connection_setup_teimeout_max_ms</td><td>=</td><td><input name='value' type='list' class=' '></td></tr>
                        <tr><td>kafka_request_timeout_ms</td><td>=</td><td><input name='value' type='list' class=' '></td></tr>
                        <tr><td><h5>SSL CONFIGS SECTION IN DOCKER TEMPLATE</td><td>
                        <tr><td>kafka_ssl_keystore_filename</td><td>=</td><td><input name='value' type='list' class=' '></td></tr>
                        <tr><td>kafka_ssl_pass_file</td><td>=</td><td><input name='value' type='list' class=' '></td></tr>
                        <tr><td>kafka_ssl_truststore_filename</td><td>=</td><td><input name='value' type='list' class=' '></td></tr>

                        <tr><td>kafka_ssl_secrets_dir</td><td>=</td><td><input name='value' type='list' class=' '></td></tr>
                        <tr><td><h5>CLUSTER CONFIGS SECTION IN DOCKER TEMPLATE</td><td>
                        <tr><td>kafka_auto_leader_rebalance_enable</td><td>=</td><td><input name='value' type='list' class=' '></td></tr>
                        <tr><td>kafka_default_replication_factor</td><td>=</td><td><input name='value' type='list' class=' '></td></tr>
                        <tr><td>kafka_offsets_topic_replication_factor</td><td>=</td><td><input name='value' type='list' class=' '></td></tr>

                        <tr><td>kafka_min_insync_replicas</td><td>=</td><td><input name='value' type='list' class=' '></td></tr>
                        <tr><td>kafka_transaction_state_log_min_isr</td><td>=</td><td><input name='value' type='list' class=' '></td></tr>
                        <tr><td>kafka_transaction_state_log_replication_factor</td><td>=</td><td><input name='value' type='list' class=' '></td></tr>

                      </table>
                      <button click="alert('hi')">clk<\button>
                      <script>
                        alert("hi");
                        let inputs = broker.getElementsByTagName('input');

                        for (let input of inputs) {
                          alert( input.name + ': ' + input.value );
                        }
                      </script>

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
                def server_arr = "${Server}".split(",")
                def broker_parameters = "${params.BROKER_parameters}".split(",")

                println "${params.old}"
                println "${params.Server}"
                println "${params.BROKER_parameters}"


                for (i in server_arr ) {
                  println "server_arr ---> ${i}"
                }

                for (i in  broker_parameters) {
                  println "broker_parameters ---> ${i}"
                }

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

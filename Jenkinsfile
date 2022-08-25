def DEPLOY_SERVICE = [
  'Clear':[],
  'Database': [
    ['service_name': 'Zookeeper'],
    ['service_name': 'Broker'],
    ['service_name': 'Kafka_Connector'],
    ['service_name': 'Connector'],
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
    ['host_service':'us-zookeeper1-1.spnode.net:2281'],
    ['host_service':'us-zookeeper1-2.spnode.net:2281'],
    ['host_service':'us-zookeeper1-3.spnode.net:2281']
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
                            if (Application == 'Kafka_Connector') {
                              return c_service['Broker'].host_service
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
//VALUE FOR KAFKA CONNECTOR DOCKER TEMPLATE
        [$class: 'DynamicReferenceParameter',
            choiceType: 'ET_FORMATTED_HTML',
            name: 'KAFKA_CONNECTOR_parameters',
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
                      if (Application == 'Kafka_Connector') {
                      return inputBox = '''
                      <table id="kafka_connector">
                        <tr><td><h5>IP SECTION IN DOCKER TEMPLATE</td><td>
                        <tr><td>container_name</td><td>=</td><td><input name='value' type='text' class=' ' placeholder="kafka-connector1-1"></td></tr>
                        <tr><td>connector_dns_name</td><td>=</td><td><input name='value' type='text' class=' ' placeholder="kafka-connector1-1.net"></td></tr>
                        <tr><td>ip_internal</td><td>=</td><td><input name='value' type='text' class=' ' placeholder="172.17.0.1"></td></tr>
                        <tr><td>connect_rest_port</td><td>=</td><td><input name='value' type='text' class=' ' placeholder="8083"></td></tr>
                        <tr><td>ip_external</td><td>=</td><td><input name='value' type='text' class=' ' placeholder="172.17.0.1"></td></tr>
                        <tr><td>connect_advertised_port</td><td>=</td><td><input name='value' type='text' class=' ' placeholder="28083"></td></tr>
                        <tr><td>ip_monitoring</td><td>=</td><td><input name='value' type='text' class=' ' placeholder="172.17.0.1"></td></tr>
                        <tr><td>monitoring_port</td><td>=</td><td><input name='value' type='text' class=' ' placeholder="9202"></td></tr>

                        <tr><td><h5>CLUSTER SETTINGS SECTION IN DOCKER TEMPLATE</td><td>
                        <tr><td>connect_group_id</td><td>=</td><td><input name='value' type='text' class=' ' placeholder="1"></td></tr>
                        <tr><td>kafka_heap_opts</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="1"></td></tr>
                        <tr><td>connect_config_storage_replication_factor</td><td>=</td><td><input name='value' type='text' class=' ' placeholder="1"></td></tr>
                        <tr><td>connect_offset_storage_replication_factor</td><td>=</td><td><input name='value' type='text' class=' ' placeholder="1"></td></tr>
                        <tr><td>connect_status_storage_replication_factor</td><td>=</td><td><input name='value' type='text' class=' ' placeholder="1"></td></tr>
                      </table>
                      '''
                      }
                    """.stripIndent()
                ]
            ],
            omitValueField: true
        ],

//VALUE FOR ZOOKEEPER DOCKER TEMPLATE
        [$class: 'DynamicReferenceParameter',
            choiceType: 'ET_FORMATTED_HTML',
            name: 'ZOOKEEPER_parameters',
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
                      if (Application == 'Zookeeper') {
                      return inputBox = '''
                      <table id="zookeeper">
                        <tr><td><h5>IP SECTION IN DOCKER TEMPLATE</td><td>
                        <tr><td>container_name</td><td>=</td><td><input name='value' type='text' class=' ' placeholder="zookeeper1-1"></td></tr>
                        <tr><td>zookeeper_dns_name</td><td>=</td><td><input name='value' type='text' class=' ' placeholder="zookeeper1-1.net"></td></tr>
                        <tr><td>ip_connect</td><td>=</td><td><input name='value' type='text' class=' ' placeholder="172.17.0.1"></td></tr>
                        <tr><td>zookeeper_secure_client_port</td><td>=</td><td><input name='value' type='text' class=' ' placeholder="2281"></td></tr>
                        <tr><td>replication_port</td><td>=</td><td><input name='value' type='text' class=' ' placeholder="2888"></td></tr>
                        <tr><td>leader_selection_port</td><td>=</td><td><input name='value' type='text' class=' ' placeholder="3888"></td></tr>

                        <tr><td><h5>ENVIROMENT SECTION IN DOCKER TEMPLATE</td><td>
                        <tr><td>zookeeper_server_id</td><td>=</td><td><input name='value' type='text' class=' ' placeholder="1"></td></tr>
                        <tr><td>kafka_zookeeper_connect</td><td>=</td><td><input name='value' type='text' class=' ' placeholder="zookeeper1-1.net:2888:3888"></td></tr>
                      </table>
                      '''
                      }
                    """.stripIndent()
                ]
            ],
            omitValueField: true
        ],
//VALUE FOR BROKER DOCKER TEMPLATE
        [$class: 'DynamicReferenceParameter',
            choiceType: 'ET_FORMATTED_HTML',
            name: 'BROKER_parameters',
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

                        <tr><td><h5>CONFIG PARAMETERS SECTION IN DOCKER TEMPLATE</td><td>
                        <tr><td>kafka_replica_fetch_max_bytes</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="20000000"></td></tr>
                        <tr><td>kafka_message_max_bytes</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="20000000"></td></tr>
                        <tr><td>kafka_log_retention_hours</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="168"></td></tr>
                        <tr><td>kafka_controller_socket_timeout_ms</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="60000"></td></tr>
                        <tr><td>kafka_connection_setup_teimeout_max_ms</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="40000"></td></tr>
                        <tr><td>kafka_request_timeout_ms</td><td>=</td><td><input name='value' type='list' class=' ' placeholder="60000"></td></tr>
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
//Overall varibles
                def server_parameters = "${Server}".split(",")
//Varibles for ZOOKEEPER DOCKER TEMPLATE
                def zoo_parameters = "${params.ZOOKEEPER_parameters}".split(",")
//Varibles for BROKER DOCKER TEMPLATE
                def mylistvalue = []
                def cafka_connector_parameters = "${params.KAFKA_CONNECTOR}".split(",")
                def zookeeper_parameters = "${params.Dependencies}".split(",")
                def broker_parameters = "${params.BROKER_parameters}".split(",")
//Add user value to mylistvalue
                for (i in broker_parameters ) {
                  mylistvalue.add(i)
                }
//Print Varibles in output states
                println "${params.old}"
                println "${server_parameters}"
                println "${cafka_connector_parameters}"
                println "${zookeeper_parameters}"
                println "${broker_parameters}"
                println "${zoo_parameters}"
            }
          }
        }

      stage('Load Kafka_pipeline') {
          steps {
            script {
                if (Application == 'Broker') {
                  echo 'Run Load Broker setup'
                  build job: 'Database/Broker', parameters: [
                    string(name: 'SERVERS', value: "${Server}"),
                    string(name: 'ZOOKEEPER_PARAMETERS', value: "${Dependencies}"),
                    string(name: 'BROKER_PARAMETERS', value: "${BROKER_parameters}")
                  ]
                } else if (Application == 'Zookeeper') {
                    echo 'Run Load Zookeeper setup'
                    build job: 'Database/Zookeeper', parameters: [
                      string(name: 'SERVERS', value: "${Server}"),
                      string(name: 'ZOOKEEPER_PARAMETERS', value: "${ZOOKEEPER_parameters}")
                    ]
                } else if (Application == 'Kafka_Connector') {
                    echo 'Run Load Kafka_Connector setup'
                    build job: 'Database/Kafka_Connector', parameters: [
                      string(name: 'SERVERS', value: "${Server}"),
                      string(name: 'KAFKA_CONNECTOR', value: "${KAFKA_CONNECTOR}"),
                      string(name: 'BROKER_PARAMETERS', value: "${BROKER_parameters}")
                    ]
                } else (Application == ' ') {ing(name: 'BROKER_PARAMETERS', value: "${BROKER_parameters}")
                      println "Nothing to do. By-By."
                }
          }
        }
      }

      }
  }

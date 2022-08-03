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
            name: 'IP_external',
            description: 'Dependencies kafka, external ip varibles',
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
                         <table>
                         <tr><td>ip_external</td><td>=</td><td><input name='value' type='list' class=' '></td></tr>
                         </table>
                         '''
                      }
                    """.stripIndent()
                ]
            ]
        ],

        [$class: 'DynamicReferenceParameter',
            choiceType: 'ET_FORMATTED_HTML',
            name: 'IP_internal',
            description: 'Dependencies kafafka, internal ip varibles',
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
                      <table>
                      <tr><td>ip_internal</td><td>=</td><td><input name='value' type='list' class=' '></td></tr>
                      </table>
                      '''
                      }
                    """.stripIndent()
                ]
            ]
        ],

        [$class: 'DynamicReferenceParameter',
            choiceType: 'ET_FORMATTED_HTML',
            name: 'Zookeeper',
            description: 'Docker file values coneect config',
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
                    script:
                      if (Application == 'Broker') {
                        FullHTML = """
                        <label style="left: 22% position: absolute;">kafka_zookeeper_ssl_keystore_location</label>
                        <input name='kafka_zookeeper_ssl_keystore_location' type='list' class=' '></input>
                        <input name='kafka_zookeeper_ssl_keystore_password' type='list' class=' '></input>
                        <input name='kafka_zookeeper_ssl_key_password' type='list' class=' '></input>
                        <input name='kafka_zookeeper_ssl_truststore_location' type='list' class=' '></input>
                        <input name='kafka_zookeeper_ssl_truststore_password' type='list' class=' '></input>
                        '''
                        return FullHTML
                      }
                ]
            ]
        ],

        [$class: 'DynamicReferenceParameter',
            choiceType: 'ET_FORMATTED_HTML',
            name: 'Docker_config_parameters',
            description: 'Docker file values section Config parameters',
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
                      <tr><td>kafka_replica_fetch_max_bytes</td><td>=</td><td><input name='kafka_replica_fetch_max_bytes' type='list' class=' '></td></tr>
                      <tr><td>kafka_message_max_bytes</td><td>=</td><td><input name='kafka_message_max_bytes' type='list' class=' '></td></tr>
                      <tr><td>kafka_log_retention_hours</td><td>=</td><td><input name='kafka_log_retention_hours' type='list' class=' '></td></tr>
                      <tr><td>kafka_controller_socket_timeout_ms</td><td>=</td><td><input name='kafka_controller_socket_timeout_ms' type='list' class=' '></td></tr>
                      <tr><td>kafka_connection_setup_teimeout_max_ms</td><td>=</td><td><input name='kafka_connection_setup_teimeout_max_ms' type='list' class=' '></td></tr>
                      <tr><td>kafka_request_timeout_ms</td><td>=</td><td><input name='kafka_request_timeout_ms' type='list' class=' '></td></tr>
                      '''
                      }
                    """.stripIndent()
                ]
            ]
        ],

        [$class: 'DynamicReferenceParameter',
            choiceType: 'ET_FORMATTED_HTML',
            name: 'Docker_ssl_config_parameters',
            description: 'Docker file values section SSL configs',
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
                      <tr><td>kafka_ssl_keystore_filename</td><td>=</td><td><input name='kafka_ssl_keystore_filename' type='list' class=' '></td></tr>
                      <tr><td>kafka_ssl_pass_file</td><td>=</td><td><input name='kafka_ssl_pass_file' type='list' class=' '></td></tr>
                      <tr><td>kafka_ssl_truststore_filename</td><td>=</td><td><input name='kafka_ssl_truststore_filename' type='list' class=' '></td></tr>
                      '''
                      return test
                      }
                    """.stripIndent()
                ]
            ]
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
        string(name: 'DNS_NAME', defaultValue: ' ', description: 'Enter dns name you service/service`s')
    }
    stages {
      stage('Deploy') {
          steps {
            script  {
                def server_arr = "${Server}".split(",")
                def ip_external = "${IP_external}".split(",")
                def ip_internal = "${IP_internal}".split(",")
                def zookeeper = "${Zookeeper}"

                println "zookeeper --->  ${Zookeeper}"

                for (i in server_arr ) {
                  println "server_arr ---> ${i}"
                }

                for (i in  ip_external) {
                  println "ip_external ---> ${i}"
                }

                for (i in  ip_internal) {
                  println "ip_internal ---> ${i}"
                }

                for (i in  zookeeper) {
                  println "zookeeper ---> ${i}"
                }
            }
          }
        }

      stage('Load Kafka_pipeline') {
          steps {
            script {
                echo 'Run Load Kafka_pipeline'
                build job: 'Database/Broker', parameters: [
                string(name: 'DNS_NAME', value: "${DNS_NAME}"),
                string(name: 'DEPENDENCIES', value: "${Dependencies}"),
                string(name: 'SERVERS', value: "${Server}"),
                string(name: 'IP_EXTERNAL', value: "${IP_external}"),
                string(name: 'IP_INTERNAL', value: "${IP_internal}")
                ]
          }
        }
      }

      }
  }

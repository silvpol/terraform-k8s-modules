resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "certificaterequests_certmanager_k8s_io" {
  metadata {
    name = "certificaterequests.certmanager.k8s.io"
  }
  spec {

    additional_printer_columns {
      json_path = <<-EOF
        .status.conditions[?(@.type=="Ready")].status
        EOF
      name      = "Ready"
      type      = "string"
    }
    additional_printer_columns {
      json_path = ".spec.issuerRef.name"
      name      = "Issuer"
      priority  = 1
      type      = "string"
    }
    additional_printer_columns {
      json_path = <<-EOF
        .status.conditions[?(@.type=="Ready")].message
        EOF
      name      = "Status"
      priority  = 1
      type      = "string"
    }
    additional_printer_columns {
      json_path   = ".metadata.creationTimestamp"
      description = "CreationTimestamp is a timestamp representing the server time when this object was created. It is not guaranteed to be set in happens-before order across separate operations. Clients may not set this value. It is represented in RFC3339 form and is in UTC."
      name        = "Age"
      type        = "date"
    }
    group = "certmanager.k8s.io"
    names {
      kind   = "CertificateRequest"
      plural = "certificaterequests"
      short_names = [
        "cr",
        "crs",
      ]
    }
    preserve_unknown_fields = false
    scope                   = "Namespaced"
    subresources {
    }
    validation {
      open_apiv3_schema = <<-JSON
        {
          "description": "CertificateRequest is a type to represent a Certificate Signing Request",
          "properties": {
            "apiVersion": {
              "description": "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#resources",
              "type": "string"
            },
            "kind": {
              "description": "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#types-kinds",
              "type": "string"
            },
            "metadata": {
              "type": "object"
            },
            "spec": {
              "description": "CertificateRequestSpec defines the desired state of CertificateRequest",
              "properties": {
                "csr": {
                  "description": "Byte slice containing the PEM encoded CertificateSigningRequest",
                  "format": "byte",
                  "type": "string"
                },
                "duration": {
                  "description": "Requested certificate default Duration",
                  "type": "string"
                },
                "isCA": {
                  "description": "IsCA will mark the resulting certificate as valid for signing. This implies that the 'cert sign' usage is set",
                  "type": "boolean"
                },
                "issuerRef": {
                  "description": "IssuerRef is a reference to the issuer for this CertificateRequest.  If the 'kind' field is not set, or set to 'Issuer', an Issuer resource with the given name in the same namespace as the CertificateRequest will be used.  If the 'kind' field is set to 'ClusterIssuer', a ClusterIssuer with the provided name will be used. The 'name' field in this stanza is required at all times. The group field refers to the API group of the issuer which defaults to 'certmanager.k8s.io' if empty.",
                  "properties": {
                    "group": {
                      "type": "string"
                    },
                    "kind": {
                      "type": "string"
                    },
                    "name": {
                      "type": "string"
                    }
                  },
                  "required": [
                    "name"
                  ],
                  "type": "object"
                },
                "usages": {
                  "description": "Usages is the set of x509 actions that are enabled for a given key. Defaults are ('digital signature', 'key encipherment') if empty",
                  "items": {
                    "description": "KeyUsage specifies valid usage contexts for keys. See: https://tools.ietf.org/html/rfc5280#section-4.2.1.3      https://tools.ietf.org/html/rfc5280#section-4.2.1.12",
                    "enum": [
                      "signing",
                      "digital signature",
                      "content commitment",
                      "key encipherment",
                      "key agreement",
                      "data encipherment",
                      "cert sign",
                      "crl sign",
                      "encipher only",
                      "decipher only",
                      "any",
                      "server auth",
                      "client auth",
                      "code signing",
                      "email protection",
                      "s/mime",
                      "ipsec end system",
                      "ipsec tunnel",
                      "ipsec user",
                      "timestamping",
                      "ocsp signing",
                      "microsoft sgc",
                      "netscape sgc"
                    ],
                    "type": "string"
                  },
                  "type": "array"
                }
              },
              "required": [
                "issuerRef"
              ],
              "type": "object"
            },
            "status": {
              "description": "CertificateStatus defines the observed state of CertificateRequest and resulting signed certificate.",
              "properties": {
                "ca": {
                  "description": "Byte slice containing the PEM encoded certificate authority of the signed certificate.",
                  "format": "byte",
                  "type": "string"
                },
                "certificate": {
                  "description": "Byte slice containing a PEM encoded signed certificate resulting from the given certificate signing request.",
                  "format": "byte",
                  "type": "string"
                },
                "conditions": {
                  "items": {
                    "description": "CertificateRequestCondition contains condition information for a CertificateRequest.",
                    "properties": {
                      "lastTransitionTime": {
                        "description": "LastTransitionTime is the timestamp corresponding to the last status change of this condition.",
                        "format": "date-time",
                        "type": "string"
                      },
                      "message": {
                        "description": "Message is a human readable description of the details of the last transition, complementing reason.",
                        "type": "string"
                      },
                      "reason": {
                        "description": "Reason is a brief machine readable explanation for the condition's last transition.",
                        "type": "string"
                      },
                      "status": {
                        "description": "Status of the condition, one of ('True', 'False', 'Unknown').",
                        "enum": [
                          "True",
                          "False",
                          "Unknown"
                        ],
                        "type": "string"
                      },
                      "type": {
                        "description": "Type of the condition, currently ('Ready').",
                        "type": "string"
                      }
                    },
                    "required": [
                      "status",
                      "type"
                    ],
                    "type": "object"
                  },
                  "type": "array"
                },
                "failureTime": {
                  "description": "FailureTime stores the time that this CertificateRequest failed. This is used to influence garbage collection and back-off.",
                  "format": "date-time",
                  "type": "string"
                }
              },
              "type": "object"
            }
          },
          "type": "object"
        }
        JSON
    }

    versions {
      name    = "v1alpha1"
      served  = true
      storage = true
    }
  }
}
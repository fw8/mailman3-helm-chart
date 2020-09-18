{{/*
Expand the name of the chart.
*/}}
{{- define "mailman3.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mailman3.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "mailman3.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mailman3.labels" -}}
helm.sh/chart: {{ include "mailman3.chart" . }}
{{ include "mailman3.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mailman3.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mailman3.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mailman3.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mailman3.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the core claimName: existingClaim if provided, otherwise claimNameOverride if provided, otherwise mailman3-core (or other fullname if overriden)
*/}}
{{- define "core.claimName" -}}
{{- if .Values.core.persistence.existingClaim -}}
{{- .Values.core.persistence.existingClaim -}}
{{- else if .Values.core.persistence.claimNameOverride -}}
{{- .Values.core.persistence.claimNameOverride -}}
{{- else -}}
{{ include "mailman3.fullname" . }}-core
{{- end -}}
{{- end -}}

{{/*
Create the web claimName: existingClaim if provided, otherwise claimNameOverride if provided, otherwise mailman3-web (or other fullname if overriden)
*/}}
{{- define "web.claimName" -}}
{{- if .Values.web.persistence.existingClaim -}}
{{- .Values.web.persistence.existingClaim -}}
{{- else if .Values.web.persistence.claimNameOverride -}}
{{- .Values.web.persistence.claimNameOverride -}}
{{- else -}}
{{ include "mailman3.fullname" . }}-web
{{- end -}}
{{- end -}}

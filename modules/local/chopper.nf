process CHOPPER {
    tag "$meta.id"
    label 'process_medium'

    conda (params.enable_conda ? "bioconda::chopper=0.8.0" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/chopper:0.8.0--hdcf5f25_0':
        'biocontainers/chopper:0.8.0--hdcf5f25_0' }"

    input:
    tuple val(meta), path(fastq)
    path  fasta

    output:
    tuple val(meta), path("*.fastq.gz"), emit: fastq
    path "*.log"                       , emit: log
    path "versions.yml"                , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    gunzip -c $fastq | chopper --contam $fasta 2> chopper.log | gzip > ${prefix}.fastq.gz
    mv chopper.log ${prefix}.chopper.log

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        chopper: \$(chopper --version 2>&1 | sed -e "s/chopper //g")
    END_VERSIONS
    """
}

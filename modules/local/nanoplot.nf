process NANOPLOT {
    tag "$meta.id"
    label 'process_low'

    conda (params.enable_conda ? 'bioconda::nanoplot=1.38.0' : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/nanoplot:1.42.0--pyhdfd78af_0' :
        'quay.io/biocontainers/nanoplot:1.42.0--pyhdfd78af_0' }"

    input:
    tuple val(meta), path(ontfile)

    output:
    tuple val(meta), path("$output_html"), emit: html
    //tuple val(meta), path("$output_png") , emit: png
    // tuple val(meta), path("$output_txt") , emit: txt
    tuple val(meta), path("$output_tsv"), emit: tsv
    tuple val(meta), path("$output_log") , emit: log
    path  "versions.yml"           , emit: versions

    script:
    //def args = task.ext.args ?: ''
    // $options.args \\
    def input_file = ("$ontfile".endsWith(".fastq.gz")) ? "--fastq ${ontfile}" :
                    ("$ontfile".endsWith(".txt")) ? "--summary ${ontfile}" : ''
    def output_dir = ("$ontfile".endsWith(".fastq.gz")) ? "fastq/${meta.id}" :
                    ("$ontfile".endsWith(".txt")) ? "summary" : ''
    output_html = output_dir+"/*.html"
    output_png  = output_dir+"/*.png"
    output_tsv  = output_dir+"/*.tsv.gz"
    output_log  = output_dir+"/*.log"
    // raw flag stores extracted data in tab separated file (for future plotting)
    // tsv_stats flag outputs stats as a tsv file
    """
    NanoPlot \\
        -t $task.cpus \\
        $input_file \\
        --raw \\
        --tsv_stats \\
        -o $output_dir
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        nanoplot: \$(echo \$(NanoPlot --version 2>&1) | sed 's/^.*NanoPlot //; s/ .*\$//')
    END_VERSIONS
    """
}

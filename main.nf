
nextflow.enable.dsl=2
params.bam = "*.bam"
params.binSize = 10
params.blacklist = ""
params.effectiveGenomeSize=2913022398
params.normalizeUsing=RPGC
params.outdir="results"

// https://deeptools.readthedocs.io/en/develop/content/tools/bamCoverage.html
process COV {
    publishDir "${params.outdir}/bigwig"
    cpus 16
    memory 32.GB
    container "https://depot.galaxyproject.org/singularity/deeptools%3A3.5.1--py_0"
    input:
        tuple val(sample_name),path(bams)
        each path(blacklist)
    output:
        path("*")    
    script:
    """
    bamCoverage \
    --bam ${bam} \
    -p ${task.cpus} \
    --normalizeUsing
    --blackListFileName ${blacklist} \
    -o a.SeqDepthNorm.${params.normalizeUsing}.bw \
    --binSize params.binSize \
    --normalizeUsing ${params.normalizeUsing} \
    --effectiveGenomeSize ${params.effectiveGenomeSize} \
    --ignoreForNormalization chrX
    """    
}

bam_ch =channel.fromPath(params.bam,checkIfExists: true)
black_ch =channel.fromPath(params.blacklist,checkIfExists: true)
workflow {
    COV(bam_ch)
}
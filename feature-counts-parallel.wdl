version 1.0
# based on https://github.com/gatk-workflows/seq-format-conversion/blob/master/cram-to-bam.wdl

workflow FeatureCountsWorkflow {

    input {
        File? ref_fasta
        File? ref_fasta_fai
        File gencode_gtf
        Array[File] input_bams_or_crams
    }

    scatter(input_bam_or_cram in input_bams_or_crams) {
        call FeatureCountsTask {
            input:
                ref_fasta=ref_fasta,
                ref_fasta_fai=ref_fasta_fai,
                gencode_gtf=gencode_gtf,
                input_bam_or_cram=input_bam_or_cram
        }
    }
}


task FeatureCountsTask {
    input {
        File? ref_fasta
        File? ref_fasta_fai
        File gencode_gtf
        File input_bam_or_cram

        String output_prefix = sub(basename(input_bam_or_cram), ".bam$||.cram$", "")
        Int disk_size = ceil(size(gencode_gtf, "GB") + size(input_bam_or_cram, "GB")) + 5
    }

    command {
        echo --------------; echo "Start - time: $(date)"; set -euxo pipefail; echo --------------

        samtools view -h \
            ~{"-T " + ref_fasta} \
            ~{input_bam_or_cram} \
        | /featureCounts --extraAttributes gene_name \
            -a ~{gencode_gtf} \
            -o ~{output_prefix}.tsv

        echo --------------; set +xe; echo "Done - time: $(date)"; echo --------------
    }

    output {
        File feature_counts_tsv="~{output_prefix}.tsv"
        File feature_counts_summary="~{output_prefix}.tsv.summary"
    }

    runtime {
        docker: "weisburd/feature-counts@sha256:30a52fc577992546223e7435cba340c03f87950555a35e4724ebbff24f24475b"
        disks: "local-disk ${disk_size} HDD"
    }
}

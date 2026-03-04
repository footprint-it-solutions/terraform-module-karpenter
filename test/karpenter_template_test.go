package test

import (
	"path/filepath"
	"testing"

	"github.com/gruntwork-io/terratest/modules/helm"
	"github.com/stretchr/testify/assert"
)

func TestKarpenterNodePoolTemplate(t *testing.T) {
	helmChartPath, err := filepath.Abs("../helm")
	assert.NoError(t, err)

	options := &helm.Options{
		ValuesFiles: []string{},
		SetValues: map[string]string{
			"nodePools[0].name":           "test-pool",
			"nodePools[0].node_class_ref": "test-class",
			"nodePools[0].requirements[0].key": "kubernetes.io/arch",
			"nodePools[0].requirements[0].operator": "In",
			"nodePools[0].requirements[0].values[0]": "amd64",
		},
	}

	// Render the template
	output := helm.RenderTemplate(t, options, helmChartPath, "karpenter-extras", []string{"templates/nodepool.yaml"})

	// Verify the output contains expected values
	assert.Contains(t, output, "name: test-pool")
	assert.Contains(t, output, "nodeClassRef:")
	assert.Contains(t, output, "name: test-class")
	assert.Contains(t, output, "key: \"kubernetes.io/arch\"")
	assert.Contains(t, output, "operator: In")
	assert.Contains(t, output, "- \"amd64\"")
}

func TestKarpenterEC2NodeClassTemplate(t *testing.T) {
	helmChartPath, err := filepath.Abs("../helm")
	assert.NoError(t, err)

	options := &helm.Options{
		ValuesFiles: []string{},
		SetValues: map[string]string{
			"ec2NodeClasses[0].name": "test-class",
			"ec2NodeClasses[0].ami_family": "AL2023",
			"ec2NodeClasses[0].subnet_selector_terms[0].tags.karpenter\\.sh/discovery": "my-cluster",
			"ec2NodeClasses[0].security_group_selector_terms[0].tags.karpenter\\.sh/discovery": "my-cluster",
		},
	}

	// Render the template
	output := helm.RenderTemplate(t, options, helmChartPath, "karpenter-extras", []string{"templates/ec2nodeclass.yaml"})

	// Verify the output contains expected values
	assert.Contains(t, output, "name: test-class")
	assert.Contains(t, output, "amiFamily: AL2023")
	assert.Contains(t, output, "karpenter.sh/discovery: my-cluster")
}

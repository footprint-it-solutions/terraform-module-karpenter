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
			"nodePools.test-pool.nodeClassRef": "test-class",
			"nodePools.test-pool.extraRequirements[0].key": "kubernetes.io/arch",
			"nodePools.test-pool.extraRequirements[0].operator": "In",
			"nodePools.test-pool.extraRequirements[0].values[0]": "amd64",
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
			"nodeClasses.test-class.amiFamily": "AL2023",
			"nodeClasses.test-class.subnetSelectorTerms[0].tags.karpenter\\.sh/discovery": "my-cluster",
			"nodeClasses.test-class.securityGroupSelectorTerms[0].tags.karpenter\\.sh/discovery": "my-cluster",
		},
	}

	// Render the template
	output := helm.RenderTemplate(t, options, helmChartPath, "karpenter-extras", []string{"templates/ec2nodeclass.yaml"})

	// Verify the output contains expected values
	assert.Contains(t, output, "name: test-class")
	assert.Contains(t, output, "amiFamily: AL2023")
	assert.Contains(t, output, "karpenter.sh/discovery: my-cluster")
}

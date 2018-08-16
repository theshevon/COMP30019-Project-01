﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaterScript : MonoBehaviour
{
    public Material material;
    private float height = 0.0f;
    private float sizeOfTerrain = LandScript.sizeOfTerrain;
    private int noOfDivisions = LandScript.noOfDivisions / 2;

    // Use this for initialization
    void Start(){

        MeshFilter terrainMesh = gameObject.AddComponent<MeshFilter>();
        terrainMesh.mesh = generateWater();

        MeshRenderer renderer = gameObject.AddComponent<MeshRenderer>();
        //renderer.material.shader = Shader.Find("Unlit/VertexColorShader");

        renderer.material = material;
    }

    private Mesh generateWater()
    {

        Mesh mesh = new Mesh();
        mesh.name = "Water";

        //There will be n+1 vertices for there to be n divisions
        Vector3[] vertices = new Vector3[(noOfDivisions + 1) * (noOfDivisions + 1)];
        Vector2[] UVs = new Vector2[vertices.Length];
        Color[] colors = new Color[vertices.Length];

        int[] triangles = new int[noOfDivisions * noOfDivisions * 6];

        float sizeOfDivision = sizeOfTerrain / noOfDivisions;

        int index;
        for (int i = 0; i < noOfDivisions + 1; i++)
        {
            for (int j = 0; j < noOfDivisions + 1; j++)
            {
                index = i * (noOfDivisions + 1) + j;

                //Set vertices
                vertices[index] = new Vector3(-(sizeOfTerrain * 0.5f) + (j * sizeOfDivision), height, (sizeOfTerrain * 0.5f) - (i * sizeOfDivision));
                UVs[index] = new Vector2((float)i / noOfDivisions, (float)j / noOfDivisions);
                colors[index] = new Color32(46, 154, 248, 1);
            }
        }


        //Make triangles
        index = 0;
        for (int i = 0; i < noOfDivisions; i++)
        {
            for (int j = 0; j < noOfDivisions; j++)
            {
                triangles[index++] = i * (noOfDivisions + 1) + j;
                triangles[index++] = (i + 1) * (noOfDivisions + 1) + j + 1;
                triangles[index++] = (i + 1) * (noOfDivisions + 1) + j;

                triangles[index++] = i * (noOfDivisions + 1) + j;
                triangles[index++] = i * (noOfDivisions + 1) + j + 1;
                triangles[index++] = (i + 1) * (noOfDivisions + 1) + j + 1;
            }
        }

        mesh.vertices = vertices;
        mesh.colors = colors;
        mesh.uv = UVs;
        mesh.triangles = triangles;

        mesh.RecalculateBounds();
        mesh.RecalculateNormals();

        return mesh;

    }

   
}


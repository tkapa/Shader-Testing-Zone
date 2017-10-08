using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class FadeOutController : MonoBehaviour {

    [Range(0, 500)]
    [Tooltip("How much of the Scene is not affected by the fade?")]
    public float minimumFadeRadius = 10.0f;

    [Range(0, 50)]
    [Tooltip("Fading speed")]
    public float fadeLength = 5.0f;

    [Tooltip("The bounding box of the fade")]
    public float minXBound = -10.0f;
    public float maxXBound = 10.0f;

    public float minYBound = -10f;
    public float maxYBound = 10f;

    // Use this for initialization
    void Update () {
        Shader.SetGlobalVector("_CenterPos", transform.position);
        Shader.SetGlobalFloat("_MinRadius", minimumFadeRadius);
        Shader.SetGlobalFloat("_MaxRadius", minimumFadeRadius + fadeLength);

        Shader.SetGlobalFloat("_MinXBound", transform.position.x - minXBound);
        Shader.SetGlobalFloat("_MaxXBound", transform.position.x + maxXBound);

        Shader.SetGlobalFloat("_MinYBound", transform.position.y - minYBound);
        Shader.SetGlobalFloat("_MaxYBound", transform.position.y + maxYBound);
        Shader.SetGlobalFloat("_FadeLength", fadeLength);
    }
}

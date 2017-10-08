using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class RectFadingController : MonoBehaviour {
    
    /// <summary>
    /// The Rect Fading Class is
    /// intended to be used with the Rect Fading Shader
    /// 
    /// - Any object with the Rect Fading Shader
    ///     will be affected by this script
    ///     
    /// - Using the Radial Fading Controller and the Rect Fading Controller
    ///     at the same time in the same scene is not advised 
    ///     
    /// </summary>

    [Range(0, 50)]
    [Tooltip("Determines the radius of terrain that is unaffected by the fade.")]
    public float fadeLength = 5.0f;

    [Tooltip("Determines the minimum X value to be unaffected by the Shader")]
    public float minXBound = 10.0f;

    [Tooltip("Determines the maximum X value to be unaffected by the Shader")]
    public float maxXBound = 10.0f;
    
    [Tooltip("Determines the minimum Y value to be unaffected by the Shader")]
    public float minYBound = 10f;
    
    [Tooltip("Determines the maximum Y value to be unaffected by the Shader")]
    public float maxYBound = 10f;

    // Use this for initialization
    void Start () {
        if (FindObjectOfType<RadialFadingController>() || GetComponent<RadialFadingController>())
            Debug.Log("Detected a Radial Fading Controller on the scene!"
                + " Using both the Rect and Radial fading controller at the same time may cause unwanted results!");

        if (FindObjectsOfType<RectFadingController>().Length > 1)
            Debug.Log("Detected another Rect Fading Controller on the scene!"
                + " Having two of the same faders at the same time will cause unwanted results");
	}
	
	// Update is called once per frame
	void Update () {
        Shader.SetGlobalFloat("_MinXBound", transform.position.x + minXBound);
        Shader.SetGlobalFloat("_MaxXBound", transform.position.x + maxXBound);

        Shader.SetGlobalFloat("_MinYBound", transform.position.y + minYBound);
        Shader.SetGlobalFloat("_MaxYBound", transform.position.y + maxYBound);
        Shader.SetGlobalFloat("_FadeLength", fadeLength);
    }
}

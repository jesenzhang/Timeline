
using UnityEngine;

public class DisplayNum 
{

	private static Color m_npcBeHitColor = Color.white;
	private static Color m_npcBehitCriticalColor = Color.yellow;
	private static Color m_playerBehitColor = Color.red;
	private static Color m_addHpColor =  new Color(0.05f,1f,0.05f);
	private static Color m_addMPColor =  new Color(0.05f,0.83f,0.97f);
	private static float m_fYOffset = 2.0f;
	private static float m_fZOffset = 0f;	


	public static void Display(int val,bool IsCritical, bool IsPlayer,Vector3 tarpos,bool bMp=false)
	{	
		if(val == 0)
		{
			return ;
		}
					
		Color color = m_npcBeHitColor;	
		if (val<0) 
		{
			if(IsPlayer)
			{
				color = m_playerBehitColor;						
			}
			else
			{									
				if(IsCritical)
				{
					color = m_npcBehitCriticalColor;						
				}
				else	
				{
					color = m_npcBeHitColor;
				}					
			}
				
		}
		else if(val>0)
		{			
			color = m_addHpColor;				
		}
		
		if(bMp)
		{
			color = m_addMPColor;
		}
	
		float size = IsCritical?0.9f:0.45f;		
		Vector3 TarInitPos = new Vector3(tarpos.x,tarpos.y+m_fYOffset,tarpos.z+m_fZOffset);	
		if(GPUBillboardBuffer.Instance()!=null)
		{
			GPUBillboardBuffer.Instance().DisplayNumber( 
				val
			    ,new Vector2( size, size )
			    ,TarInitPos
			    ,color
			    ,IsCritical);
		}

	}

}

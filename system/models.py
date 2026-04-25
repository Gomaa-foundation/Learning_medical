from pydantic import BaseModel, Field
from typing import List, Optional, Dict
from datetime import date

class CurriculumItem(BaseModel):
    phase: int
    title: str
    source: str
    status: str
    focus: Optional[str] = None

class Resource(BaseModel):
    id: str
    title: str
    role: str
    author: Optional[str] = None

class SkillNode(BaseModel):
    difficulty: float = 5.0
    p_mastery: float = 0.1
    stability: float = 2.0
    last_review: Optional[date] = None
    due: Optional[date] = None

class TrackerSchema(BaseModel):
    curriculum: List[CurriculumItem]
    resources: List[Resource]
    skills: Dict[str, SkillNode]
